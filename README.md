# Python Binding of SOLVESPACE Constraint Solver

`py_slvs` is a Python binding of the 2D/3D geometry constraint solver from a
[forked version](https://github.com/realthunder/solvespace) of
[SOLVESPACE](http://solvespace.com/). 

The fork is based on SOLVESPACE v2.3, with some memory optimization
on Linux build. The Python binding is done using [SWIG](http://www.swig.org/)
and modeled straight from SOLVESPACE's solver library 
(see [here](https://github.com/realthunder/solvespace/blob/python/exposed/DOC.txt)
and [here](https://github.com/realthunder/solvespace/blob/python/include/slvs.h)),
and is thus considered fairly low level.

The binding is currently used to implement the primiary solver for
FreeCAD [assembly3](https://github.com/realthunder/FreeCAD_assembly3) workbench

