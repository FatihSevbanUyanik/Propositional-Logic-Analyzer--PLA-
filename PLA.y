%token NUM_INDICATOR BOOLEAN INTEGER DOUBLE STRING COMMENT IF ELSE WHILE FOR RETURN LP RP LSB RSB LCB RCB EXCLAMATION COMMA PLUS MINUS DIVISION MULTIPLICATION OR AND NOT NOR NAND XOR IMPLICATION IF_AND_ONLY_IF LESS_THAN LESS_THAN_EQ GREATER_THAN GREATER_THAN_EQ PREDICATE PREDICATE_CALLER COLON PRINT PRINTLN VARIABLE_LOGIC CONSTANT_LOGIC VARIABLE_STRING CONSTANT_STRING VARIABLE_LIST VARIABLE_NUMERIC CONSTANT_NUMERIC INPUT IDENTIFIER SEMICOLON EQUALITY_OP NON_EQUALITY_OP ASSIGNMENT CONSTANT_LIST
%%

program:                    IDENTIFIER LCB statements RCB {printf("Input program is valid\n"); return 0;} | IDENTIFIER LCB empty RCB {printf("Input program is valid\n"); return 0;};

statements:                 statement SEMICOLON | statement SEMICOLON statements | COMMENT | COMMENT statements;

statement:                  if_stmt | for_each | while_loop | predicate_declaration | predicate_call | var_logic_declaration 
                            | var_logic_assignment | val_logic_declaration  | var_string_declaration | var_string_assignment 
                            | val_string_assignment | input_statement |  print_statements | var_list_declaration | var_list_assignment 
                            | val_list_assignment |var_num_declaration | var_num_assignment | val_num_assignment | list_element_assignment;


var_num_declaration:        VARIABLE_NUMERIC NUM_INDICATOR IDENTIFIER | VARIABLE_NUMERIC var_num_assignment;

var_num_assignment:         NUM_INDICATOR IDENTIFIER ASSIGNMENT operation_numeric;

val_num_assignment:         CONSTANT_NUMERIC NUM_INDICATOR IDENTIFIER ASSIGNMENT operation_numeric;
                    
var_list_declaration:       VARIABLE_LIST IDENTIFIER | VARIABLE_LIST var_list_assignment;

var_list_assignment:        IDENTIFIER ASSIGNMENT list;

val_list_assignment:        CONSTANT_LIST IDENTIFIER ASSIGNMENT list; 

var_string_declaration:     VARIABLE_STRING IDENTIFIER | VARIABLE_STRING var_string_assignment;

var_string_assignment:      IDENTIFIER ASSIGNMENT STRING;

val_string_assignment:      CONSTANT_STRING IDENTIFIER ASSIGNMENT STRING;

var_logic_declaration:      VARIABLE_LOGIC IDENTIFIER | VARIABLE_LOGIC var_logic_assignment;

var_logic_assignment:       IDENTIFIER ASSIGNMENT operation_boolean;

val_logic_declaration:      CONSTANT_LOGIC IDENTIFIER ASSIGNMENT operation_boolean;

operation_numeric:          operation_numeric operator_sub_sum term_numeric | term_numeric;

term_numeric:               term_numeric operator_mult_div factor_numeric | factor_numeric;

factor_numeric:             LP operation_numeric RP | property_numeric;

operation_boolean:          operation_boolean operator_boolean term_boolean | term_boolean;

term_boolean:               LP logic_expression RP | property_boolean | NOT property_boolean;

property:                   operation_numeric | STRING | operation_boolean | list;

property_numeric:           INTEGER | DOUBLE | NUM_INDICATOR IDENTIFIER | NUM_INDICATOR list_element_call;

property_boolean:           BOOLEAN | predicate_call | IDENTIFIER | list_element_call; 

property_list:              empty | property | property COMMA property_list;

list:                       LSB property_list RSB;

list_element_call:          IDENTIFIER LSB operation_numeric RSB;

list_element_assignment:    list_element_call ASSIGNMENT property;

operator_boolean:           AND | OR | XOR | IF_AND_ONLY_IF | IMPLICATION | NAND | NOR;

operator_mult_div:          MULTIPLICATION | DIVISION;

operator_sub_sum:           PLUS | MINUS;

comparison_operator:        LESS_THAN | GREATER_THAN | LESS_THAN_EQ | GREATER_THAN_EQ | EQUALITY_OP | NON_EQUALITY_OP;

predicate_declaration:      PREDICATE IDENTIFIER LP param_list RP PREDICATE_CALLER LCB statements_predicate RETURN logic_expression SEMICOLON RCB;

param_list:                 empty | param | param COMMA param_list;

param:                      IDENTIFIER | NUM_INDICATOR IDENTIFIER;                   

statements_predicate:       statements | empty;   

predicate_call:             IDENTIFIER LP property_list RP;

logic_expression:           logic_expression_numeric | operation_boolean;

logic_expression_numeric:   operation_numeric comparison_operator operation_numeric;

if_stmt:                    IF LP logic_expression RP LCB statements RCB 
                            | IF LP logic_expression RP LCB statements RCB ELSE LCB statements RCB;

for_each:                   FOR LP IDENTIFIER COLON list RP LCB statements RCB 
                            | FOR LP IDENTIFIER COLON IDENTIFIER RP LCB statements RCB; 

while_loop:                 WHILE LP logic_expression RP LCB statements RCB;

input_statement:            INPUT IDENTIFIER | INPUT NUM_INDICATOR IDENTIFIER;

print_statements:           print | println;

print:                      PRINT LP property_list RP;

println:                    PRINTLN LP property_list RP;

empty:                      ;

%%
#include "lex.yy.c"

int yyerror(char* s){
  fprintf(stderr, "%s on line %d\n",s, yylineno);
  return 1;
}

int main(){
  yyparse();
  return 0;
}
