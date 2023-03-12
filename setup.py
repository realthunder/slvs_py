from skbuild import setup

import os, io
this_directory = os.path.abspath(os.path.dirname(__file__))
with io.open(os.path.join(this_directory, 'README.md'), encoding='utf-8') as f:
    long_description = f.read()

if __name__ == '__main__':
    setup(
        name='py_slvs',
        version='1.0.5',
        packages=['slvs'],
        license='Gnu General Public License 3.0',
        author='Zheng, Lei',
        author_email='realthunder.dev@gmail.com',
        cmake_args=['-DENABLE_GUI:BOOL=OFF','-DBUILD_PYTHON:BOOL=ON'],
        cmake_source_dir='slvs',
        url='https://github.com/realthunder/slvs_py',
        description='Python binding of SOLVESPACE geometry constraint solver',
        long_description=long_description,
        long_description_content_type='text/markdown'
    )
