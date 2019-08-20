from skbuild import setup

if __name__ == '__main__':
    setup(
        name='py_slvs',
        version='1.0.0',
        packages=['py_slvs'],
        license='Gnu General Public License 3.0',
        author='Zheng, Lei',
        author_email='realthunder.dev@gmail.com',
        cmake_args=['-DENABLE_GUI:BOOL=OFF','-DBUILD_PYTHON:BOOL=ON'],
        cmake_source_dir='slvs',
        url='https://github.com/realthunder/solvespace'
    )
