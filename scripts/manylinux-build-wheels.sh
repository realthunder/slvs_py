#!/usr/bin/env bash

# -----------------------------------------------------------------------
# These variables are set in common script:
#

set -e

ARCH=""
PYBINARIES=""
PYTHON_LIBRARY=""

DEPS_PREFIX=/work/deps/usr
SWIG_EXECUTABLE=$DEPS_PREFIX/bin/swig
export PCRE_CONFIG=$DEPS_PREFIX/bin/pcre-config

if ! test -f $PCRE_CONFIG; then
    pushd /work/deps/pcre
    ./configure --prefix=$DEPS_PREFIX
    make install
    popd
fi

if ! test -f $SWIG_EXECUTABLE; then
    pushd /work/deps/swig
    ./configure --prefix=$DEPS_PREFIX --without-perl5 --without-tcl --without-java \
        --without-ruby --without-javascript --without-lua \
        --with-python=/opt/python/cp27/bin/python \
        --with-python3=/opt/python/cp37/bin/python
    make && make install
    popd
fi

export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$DEPS_PREFIX/lib"

script_dir=$(cd $(dirname $0) || exit 1; pwd)
source "${script_dir}/manylinux-build-common.sh"
# -----------------------------------------------------------------------

# Compile wheels re-using standalone project and archive cache
for PYBIN in "${PYBINARIES[@]}"; do
    export PYTHON_EXECUTABLE=${PYBIN}/python
    PYTHON_INCLUDE_DIR=$( find -L ${PYBIN}/../include/ -name Python.h -exec dirname {} \; )

    echo ""
    echo "PYTHON_EXECUTABLE:${PYTHON_EXECUTABLE}"
    echo "PYTHON_INCLUDE_DIR:${PYTHON_INCLUDE_DIR}"
    echo "PYTHON_LIBRARY:${PYTHON_LIBRARY}"

    # PY_VER=$(basename $(dirname ${PYBIN}))

    # Install dependencies
    # ${PYBIN}/pip install --upgrade -r /work/requirements-dev.txt

    build_type=MinSizeRel
    build_path=/work/_skbuild

    # Clean up previous invocations
    rm -rf ${build_path}

    # Generate wheel
    ${PYBIN}/python setup.py bdist_wheel --build-type ${build_type} -G Ninja -- \
          -DCMAKE_CXX_COMPILER_TARGET:STRING=$(uname -p)-linux-gnu \
          -DPYTHON_EXECUTABLE:FILEPATH=${PYTHON_EXECUTABLE} \
          -DPYTHON_INCLUDE_DIR:PATH=${PYTHON_INCLUDE_DIR} \
          -DPYTHON_LIBRARY:FILEPATH=${PYTHON_LIBRARY} \
          -DSWIG_EXECUTABLE:FILEPATH=${SWIG_EXECUTABLE}
    # Cleanup
    ${PYBIN}/python setup.py clean
done

# Fixup the wheels (update from 'linux' to 'manylinux1' tag)
for whl in dist/*linux_$(uname -p).whl; do
    # XXX Explicitly specify lib subdirectory to copy needed libraries
    auditwheel repair ${whl} --lib-sdir . -w /work/dist/
    rm ${whl}
done

