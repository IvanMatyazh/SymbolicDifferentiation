# SymbolicDifferentiation
Symbolic differentiation in Prolog

To load the program in SWI-Prolog:
['PathToRepo/differentiate'].

Example of usage:
differentiate(cos(2*x), x, Ans).
Output:
Ans = -sin(2*x)*2.

Besides the usual +,-,*,/ operators and numbers, any of the following functions is supported too: (sin cos tg ctg sqrt exp ln log asin acos atg actg), as well is the symbol ^, which is an alias for the power function.