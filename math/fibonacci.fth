\ Copyright 2017 Fredrik Noring

require core/reverse.fth

\ Remove xt from the stack and compute the Fibonacci numbers F_0, F_1, ....
\ The invoked xt has the stack effect ( i * x n -- j * x flag ).
\ traverse-fibonaccis does not put any items other than the Fibonacci number n
\ on the stack when calling xt, so that xt can access and modify the rest of
\ the stack. If flag is true, continue with the next Fibonacci number, else
\ return.
: traverse-fibonaccis ( xt -- )
	0 1 { xt a b }
	begin	a xt execute
	while	a b + b to a to b
	repeat ;

\ FIXME Computing the Fibonacci number in matrix form enables very fast
\ exponentiation and inversion so that stack reversal can be avoided. However,
\ the number of useful Fibonacci numbers is very limited due to integer
\ overflow, so it might not matter in practice.

: fibonaccis' ( n1 n2 -- n2 n3 true | false )
	swap dup 1 <= if drop false else 1- true then ;
\ Remove n from the stack and compute F_0, F_1, ..., F_{n-1} up to and
\ including Fibonacci number n-1 with F_0 at the top of the stack.
: fibonaccis { n1 -- n1 * n }
   n1 ['] fibonaccis' traverse-fibonaccis n1 reverse ;

: fibonacci' ( k n n -- k-1 n true | n false )
	nip swap dup 1 < if drop false else 1- swap true then ;
\ Remove n from the stack and compute F_n, the nth Fibonacci number.
: fibonacci ( n1 -- n2 ) 0 ['] fibonacci' traverse-fibonaccis ;
