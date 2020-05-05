%{
void yyerror (char *s);
int yylex();
#include <stdio.h>     
#include <stdlib.h>
#include <ctype.h>
#include<math.h>
float array[100];
float elements[52][51];
float factorial(float n);
int position;
float power(float a, float b);
float find(char variableName, int index);
void createArray(char variableName, int type);
void addElement(float val);
void printArrayy(char variableName);
float calclogarithm (float val);
float rootsOfPolynomial(char variableName);
float functionVal(char variableName, float val);
void functionDiff(char variableName);
float functionDiffVal(char variableName, float val);
void appendA(char s1);
void arrayMutation(char variableName, int type);
void popAction(char variableName);
void findTypeOf(char variableName);
int findIndex(char a);
%}

%union {float num; char id;}         
%start statement
%token evaluateExpression
%token func
%token evaluateFunction
%token evaluateDifferentiation
%token differentiate
%token show
%token type_of
%token append
%token pop
%token root
%token exit_command
%token exponent
%token logarithm
%token <num> number 
%token <num> element
%token <id> variable
%type <num> statement E term expression operation
%type <id> assignment

%right '='
%left '*' '/' 
%left '+' '-'  
%right '^' '%'
%left '(' ')'
%left  '<' '>'
%left '@' '!'
%right '_'

%%

statement    : assignment ';'											{;}
		| exit_command ';'												{exit(EXIT_SUCCESS);}
		| evaluateExpression expression';'								{printf( "=> %f\n", ($2));}
		| variable '.' operation  ';'									{arrayMutation($1, $3);}
		| show variable';'											{ printArrayy($2);}
		| type_of variable			';'								{findTypeOf($2);}
		| statement assignment ';'										{;}
		| statement evaluateExpression expression ';'					{printf( "=> %f\n", ($3));}
		| statement variable '.' operation  ';'						{arrayMutation($2, $4);}	
		| statement show variable';'									{ printArrayy($3); }
		| statement type_of variable	';'								{findTypeOf($3);}
		| statement exit_command ';'									{exit(EXIT_SUCCESS);}
        ;




assignment : variable '=' DS 		{ createArray($1, 0); }
		  | variable '=' polynomial { createArray($1, 1); }
		  | variable '=' differentiation { createArray($1, 1);}	
		  

polynomial : func '(' arrayelements ')'
differentiation : differentiate '(' variable ')'  {functionDiff($3);}

DS	:  	  '{' arrayelements '}'
		| expression				{addElement($1);}

operation : append '(' arrayelements ')' {$$ = 0;}
		  | pop	    				      {$$ = 1;}
		  

arrayelements: arrayelements ',' expression 	{addElement($3);}
		|  expression 			{addElement($1);}

expression : E				{$$ = $1; }
E    	: E '+' E			{$$ = $1 + $3; }
       	| E '-' E      		{$$ = $1 - $3;}
		| E '/' E      		{	if($3 == 0) {
										yyerror("Division by 0");
										exit(EXIT_SUCCESS);
									}
									$$ = $1 / $3;
								}
		| E '^' E		{$$ = power($1, $3);}
		| E '*' E			{$$ = $1 * $3; }
		| '('  E  ')'       	{ $$ = $2; }
		| E '!'				{$$ = factorial($1); }
		| exponent '(' E ')'	{$$ = power(2.71, $3); }
		| logarithm '(' E ')'	{$$ = calclogarithm($3); }
		| '-' E %prec '_'     { $$ = -1*($2); }
		| term                  {$$ = $1;}
		| evaluateFunction '(' variable  expression ')' 		{$$ = functionVal($3, $4);}
		| root variable 		{$$ = rootsOfPolynomial($2);}
		| evaluateDifferentiation '(' variable expression')'  {$$ = functionDiffVal($3, $4);}
		
       	;

term   	: number                	{$$ = $1;}
		| variable				{$$ = find($1, 1);} 
		| variable '<' number '>' {$$ = find($1, $3);}
        ;

%%                     

void showError(int type) {

}

void clearStorage(){
	for(int i = 0; i < 52; ++i)
		for(int j = 0;j < 51; ++j) {
			elements[i][j] = 0;
		}
}

int findIndex(char a) {
	if(islower(a)) 
		return (a+26-'a');
	return (a-'A');
} 

void findTypeOf(char variableName) {
	int ind = findIndex(variableName);
	int type = elements[ind][50];
	if(type == 0) printf("=> Vector\n");
	else if(type == 1) printf("=> Polynomial\n");
}


void functionDiff(char variableName) {
	int ind = findIndex(variableName);
	if(elements[ind][50] == 0) {
		printf("Given argument is not a Polynomial (Array is given)\n");
		exit(EXIT_SUCCESS);
	}
	for(int i = 1; i < 50-1; ++i){ 
		array[position++] = elements[ind][i+1]*i;
	}
}

float functionDiffVal(char variableName, float val) {
	int ind = findIndex(variableName);
	if(elements[ind][50] == 0) {
		printf("Given argument is not a Polynomial (Array is given)\n");
		exit(EXIT_SUCCESS);
	}
	
	float sum = 0;
	for(int i = 2; i < 50; ++i){ 
		sum += elements[ind][i]*(i-1)*power(val, (i-2));
	}
	// printf("%f\n", sum);
	return sum;
}

void appendA(char variableName) {
	int ind = findIndex(variableName);
	int length = elements[ind][0];
	for(int i = 0;i < position; ++i) {
		elements[ind][length+i+1] = array[i];
	}
	elements[ind][0] += position;
	position = 0;
}

void popAction(char variableName) {
	int ind = findIndex(variableName);
	int length = elements[ind][0];
	elements[ind][length] = 0;
	elements[ind][0]--;
}

void arrayMutation(char variableName, int type) {
	int ind = findIndex(variableName);
	if(elements[ind][50] == 1) {
		printf("Given argument is not an array. (Polynomial is given)\n");
		exit(EXIT_SUCCESS);
	}
	switch(type) {
		case(0):
			appendA(variableName);
		case(1):
			popAction(variableName);
	}
}

float power(float a, float b) {
	float power = pow(a,b);
	return power;
}

float factorial(float n) {
	if(n < 0) {
		printf("Factorial of a negative number is not defined\n");
		exit(EXIT_SUCCESS);
	}
	float fac = 1;
	for(float i = 1; i <= (int)n; ++i) {
		fac *= i;
	}
	return fac;
}


float calclogarithm (float val) {
	if(val <= 0) {
		printf("Logarithm of negative numbers is not defined\n");
		exit(EXIT_SUCCESS);
	}
	return log(val);
}

float find(char variableName, int index) {
	int ind = findIndex(variableName);
	if(elements[ind][50] == 1) {
		printf("Given argument is not an array. (Polynomial is given)\n");
		exit(EXIT_SUCCESS);
	}
	
	// printf("%d, %d", index, elements[ind][index]);
	return elements[ind][index];
}

void createArray(char variableName, int type) {
	int ind = findIndex(variableName);
	elements[ind][0] = position;
	for(int i = 1; i < position+1; ++i){
		elements[ind][i] = array[i-1];
		array[i-1] = 0;
	}
	position = 0;
	elements[ind][50] = type;
}

void addElement(float val) {
	array[position++] = val;
}

void printArrayy(char variableName) {
	
	int ind = findIndex(variableName);
	float length = elements[ind][0];
	printf("=> ");
	for(int i = 0;i < (int)length; ++i) {
		printf("%f ", elements[ind][i+1]); 
	}
	printf("\n");
}

float functionVal(char variableName, float val) {
	// printf("ok %c %f\n", variableName, val);
	int ind = findIndex(variableName);
	if(elements[ind][50] == 0) {
		printf("Given argument is not a Polynomial (Array is given)\n");
		exit(EXIT_SUCCESS);
	}
	
	float sum = 0;
	for(int i = 1; i < 50; ++i) {
		sum += (elements[ind][i] * power(val, i-1)); 
	}
	return sum;
}

float rootsOfPolynomial(char variableName) {
	// Finding root of a function using Secant Method
	float x0,x1,x2,error;
	int i=0;
	x0 = 0; x1 = 1;
	// printf("Ite\tX0\t\tX1\t\tf(X0)\t\tf(X1)\t\tError\n");
	do{
		x2=((x0*functionVal(variableName, x1))-((x1)*functionVal(variableName ,x0)))/((functionVal(variableName, x1)-functionVal(variableName, x0)));
		// printf("%2d\t%4.6f\t%4.6f\t%4.6f\t%4.6f\t%4.6f\n",i++,x0,x1,functionVal(variableName,x0),functionVal(variableName,x1),error);
		error=fabs((x2)-(x1));
		x0=x1;
		x1=x2;
		
	}while(error>0.00005);
	return x1;
}

int main (void) {
	position = 0;
	clearStorage();
	return yyparse ( );
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 

