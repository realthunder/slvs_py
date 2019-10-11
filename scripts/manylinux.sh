#!/bin/bash

# sudo=sudo
# docker=manylinux-x64-swig
# pcre_ver=8.38
# swig_ver=4.0.1
#
# $sudo docker build -t $docker -f - << EOS
# FROM dockcross/manylinux-x64
#
# RUN wget --quiet -O pcre_ver.tar.gz \
#         "https://ftp.pcre.org/pub/pcre/pcre-$pcre_ver.tar.gz";\
#     tar xf pcre.tar.gz && \
#     cd pcre-$pcre_ver && \
#     ./configure && \
#     make install && \
#     cd .. && \
#     rm -rf pcre*
#
# RUN wget --quiet -O swig.tar.gz \
#         "http://downloads.sourceforge.net/project/swig/swig/swig-$swig_ver/swig-$swig_ver.tar.gz";\
#     tar xf swig.tar.gz && \
#     cd swig-$swig_ver && \
#     ./configure --prefix=/usr --without-perl5 --without-tcl --without-java --without-ruby \
#                  --without-javascript --without-lua && \
#     make && make install && \
#     cd .. && \
#     rm -rf swig*
#
# EOS

# Pull dockcross manylinux images
sudo docker pull dockcross/manylinux-x64
#docker pull dockcross/manylinux-x86

# Generate dockcross scripts
# sudo docker run dockcross/manylinux-x64 > /tmp/dockcross-manylinux-x64
# chmod u+x /tmp/dockcross-manylinux-x64
# docker run dockcross/manylinux-x86 > /tmp/dockcross-manylinux-x86
# chmod u+x /tmp/dockcross-manylinux-x86

script_dir=$(cd $(dirname $0) || exit 1; pwd)

# Build wheels
pushd $script_dir/..

if ! test -d deps/pcre; then
    pushd deps
    pcre_ver=8.38
    wget "https://ftp.pcre.org/pub/pcre/pcre-$pcre_ver.tar.gz"
    tar xf pcre-$pcre_ver.tar.gz
    mv pcre-$pcre_ver pcre
    popd
fi

mkdir -p deps
if ! test -d deps/swig; then
    pushd deps
    swig_ver=4.0.1
    wget "http://downloads.sourceforge.net/project/swig/swig/swig-$swig_ver/swig-$swig_ver.tar.gz"
    tar xf swig-$swig_ver.tar.gz
    mv swig-$swig_ver swig
    popd
fi

./scripts/dockcross-manylinux-x64 ./scripts/manylinux-build-wheels.sh "$@"

popd
