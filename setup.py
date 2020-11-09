from skbuild import setup

from os import path
from io import open
this_directory = path.abspath(path.dirname(__file__))
with open(path.join(this_directory, 'README.md'), encoding='utf-8') as f:
    long_description = f.read()

if __name__ == '__main__':
    setup(
        name='py_slvs',
        version='1.0.0',
        packages=['py_slvs'],
        license='Gnu General Public License 3.0',
        author='Zheng, Lei',
        author_email='realthunder.dev@gmail.com',
        cmake_args=['-DENABLE_GUI:BOOL=OFF','-DBUILD_PYTHON:BOOL=ON'],
        build_tool_args=['-w', 'dupbuild=warn'],
        cmake_source_dir='slvs',
        url='https://github.com/realthunder/slvs_py',
        description='Python binding of SOLVESPACE geometry constraint solver',
        long_description=long_description,
        long_description_content_type='text/markdown'
    )
