# MathLib

MathLib is parser and lexical analyser that performs complex mathematical operations by using basic mathematical symbols built using Lex and Yacc. The target is to make it more readable for mathematicians and help them code in the same manner as they solve questions on paper. 

There are two types of variables in the grammar, named Vector and Polynomials. Declaration of polynomials begin with ‘@’.

### Using MathLib

Write your test code in `input.txt`

`git clone ` \
`cd MathLib` \
`lex mathLib.l` \
`yacc -d mathlib.y` \
`gcc lex.yy.c y.tab.c -o mathLib` \
`./mathLib < input.txt`

### A few examples

Calculus:
```
f = @ (2, 3, 4);  /* defines a polynomial of the form 4x^2 + 3x + 2 */

x = evalFun(f 5!);    /* returns f(120) */
v = evalDiff(f 2^3);   /* returns f'(8) */
r = root f;          /* returns one of the roots of polynomial, using the Secant Method */
show x;
show v;
show r;
over;
```


Algebra:
```
a = 1;
b = 5;
c = a + b;
c = a! + a^b + log(c) + c/b;
show c; /* prints 1.958352 in the console */
```

Arrays:
```
b = 3;
c = log(b);
a={1,b!,3,c^3};
v = a<0>;             /* returns the first element of array i.e. 1 */
a.append(5, 6);   /* changes a to {1,6,3,0.108614,5,6} */
a.pop;            /* changes a to {1,6,3,0.108614,5} */
```

Please feel free to raise issues to suggest grammar changes or new features.










