%optimize sum%
sum(A, 0, A).

sum(0, A, A).

sum(A, B, Sum) :-
    number(A),
    number(B),
    Sum is A + B.

sum(A, B, A + B).

%optimize substraction%
sub(A, 0, A).

sub(0, A, -A).

sub(A, B, 0) :-
    A == B.

sub(A, B, Sub) :-
    number(A),
    number(B),
    Sub is A - B.

sub(A, B, A - B).

%optimize multiplication%
mult(A, 1, A).

mult(1, A, A).

mult(0, _, 0).

mult(_, 0, 0).

mult(A, B, Mult) :-
    number(A),
    number(B),
    Mult is A * B.

mult(A, B, A * B).

%optimize division%
div(A, 1, A).

div(A, A, 1).

div(0, _, 0).

div(A, B, 1) :-
    A == B.

div(A, B, Div) :-
    number(A),
    number(B),
    Div is A / B.

div(A, B, A / B).

%derivative of constant%
differentiate(Eq, _, 0) :-
    number(Eq).

%derivative of other variable%
differentiate(Eq, Var, 0) :-
	atom(Eq),
	Eq \== Var.

%derivative of the same variable%
differentiate(Eq, Var, 1) :-
    atom(Eq),
    Eq == Var.

%sum rule: (f + g)' = f' + g'%
differentiate(Eq1 + Eq2, Var, Ans) :-
	differentiate(Eq1, Var, Eqd1),
	differentiate(Eq2, Var, Eqd2),
	sum(Eqd1, Eqd2, Ans).

%difference rule: (f - g)' = f' - g'%
differentiate(Eq1 - Eq2, Var, Ans) :-
    differentiate(Eq1, Var, Eqd1),
    differentiate(Eq2, Var, Eqd2),
    sub(Eqd1, Eqd2, Ans).

%product rule: (f*g)' = f'*g + f*g'%
differentiate(Eq1 * Eq2, Var, Ans) :-
    differentiate(Eq1, Var, Eqd1),
    differentiate(Eq2, Var, Eqd2),
    mult(Eqd1, Eq2, R),
    mult(Eq1, Eqd2, L),
    sum(R, L, Ans).

%division rule: (f/g)' = (f'*g - f*g')/(g*g)%
differentiate(Eq1 / Eq2, Var, Ans) :-
    differentiate(Eq1, Var, Eqd1),
    differentiate(Eq2, Var, Eqd2),
    mult(Eqd1, Eq2, R),
    mult(Eq1, Eqd2, L),
    mult(Eq2, Eq2, Denom),
    sub(R, L, Nom),
    div(Nom, Denom, Ans).

%exp(f)' = exp(f)*f'%
differentiate(exp(Eq), Var, Ans) :-
    differentiate(Eq, Var, Eqd),
    mult(exp(Eq), Eqd, Ans).

%sin(f)' = cos(f)*f'%
differentiate(sin(Eq), Var, Ans) :-
    differentiate(Eq, Var, Eqd),
    mult(cos(Eq), Eqd, Ans).

%cos(f)' = -sin(f)*f'%
differentiate(cos(Eq), Var, Ans) :-
    differentiate(Eq, Var, Eqd),
    mult(-sin(Eq), Eqd, Ans).

%tg(f)' = 1/cos(f)^2*f'%
differentiate(tg(Eq), Var, Ans) :-
    differentiate(Eq, Var, Eqd),
    div(Eqd, (cos(Eq)^2), Ans).

%ctg(f)' = -1/sin(f)^2*f'%
differentiate(ctg(Eq), Var, Ans) :-
    differentiate(Eq, Var, Eqd),
    div(-Eqd, (sin(Eq)^2), Ans).

%sqrt(f)' = 1/(2*sqrt(f))*f'%
differentiate(sqrt(Eq), Var, Ans) :-
    differentiate(Eq, Var, Eqd),
    div(Eqd, (2*sqrt(Eq)), Ans).

%ln(f)' = 1/f*f'%
differentiate(ln(Eq), Var, Ans) :-
    differentiate(Eq, Var, Eqd),
    div(Eqd, Eq, Ans).

%log(f)' = 1/(f*ln(10))*f'%
differentiate(log(Eq), Var, Ans) :-
    differentiate(Eq, Var, Eqd),
    div(Eqd, (Eq * ln(10)), Ans).

%acos(f)' = -1/sqrt(1 - f^2)*f'%
differentiate(acos(Eq), Var, Ans) :-
    differentiate(Eq, Var, Eqd),
    div(-Eqd, (sqrt(1 - (Eq)^2)), Ans).

%asin(f)' = 1/sqrt(1 - f^2)*f'%
differentiate(asin(Eq), Var, Ans) :-
    differentiate(Eq, Var, Eqd),
    div(Eqd, (sqrt(1 - (Eq)^2)), Ans).

%atg(f)' = 1/(1 + f^2)*f'%
differentiate(atg(Eq), Var, Ans) :-
    differentiate(Eq, Var, Eqd),
    div(Eqd, (1 + (Eq)^2), Ans).

%actg(f)' = -1/(1 + f^2)*f'%
differentiate(atg(Eq), Var, Ans) :-
    differentiate(Eq, Var, Eqd),
    div(-Eqd, (1 + (Eq)^2), Ans).

%(f^a)' = a*f^(a - 1)*f'%
differentiate(Eq ^ Num, Var, Ans) :-
    number(Num),
    differentiate(Eq, Var, Eqd),
    sub(Num, 1, Pow),
    mult(Num, (Eq)^Pow, R),
    mult(R, Eqd, Ans).

%(a^f)' = a^f*ln(a)*f'%
differentiate(Num ^ Eq, Var, Ans) :-
    number(Num),
    differentiate(Eq, Var, Eqd),
    mult(Num^(Eq), ln(Num), R),
    mult(R, Eqd, Ans).

%(f^g)' = exp(f*ln(g))*(f*ln(g))'%
differentiate(Eq1 ^ Eq2, Var, Ans) :-
    differentiate(Eq1 * ln(Eq2), Var, Eqd),
    mult(exp(Eq1 * ln(Eq2)), Eqd, Ans).