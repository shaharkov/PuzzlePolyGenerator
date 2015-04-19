Puzzles Polynomial System Generator
====

Supplemental Matlab code for the paper ["A Global Approach for Solving Edge-Matching Puzzles"](http://www.wisdom.weizmann.ac.il/~shaharko/projects/GlobalPuzzles.pdf).

----
This package computes the polynomial system corresponding to a random 2d square tiling puzzle (as described in the paper). 

The script `script_GeneratePuzzlePolynomialSystem.m` follows these steps:
- Generates a random puzzle.
- Generates the corresponding polynomial system of a user prescribed order (see Section 4.2 in the paper).
- Verifies that the solutions of the puzzle (searched exhaustively) satisfy the linear system.

The computed polynomial system is encoded by the linear system `(A,b)`. Each row corresponds to an equation. Each column of A corresponds to monomial in `exp(t_i)` of the `i`'th piece. (For more details, see the last block of the code as well as the function `getLiftedValues.m`.)

**Disclaimer:**
The code is provided as-is for academic use only and without any guarantees. Please contact the authors to report any bugs.
Written by [Shahar Kovalsky](http://www.wisdom.weizmann.ac.il/~shaharko/) and [Daniel Glasner](https://sites.google.com/site/dglasner/)