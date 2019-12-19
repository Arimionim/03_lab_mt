{
module Parser where

import Grammar
import Lexer
}

%name      parseExpr
%tokentype { Token }
%error     { parseError }
%monad     { Either String }{ >>= }{ return }


%token
    BEGIN       { TBegin }
    END         { TEnd }
    IF          { TIf }
    PORTAL      { TPortal }
    IN          { TIn }
    OUT         { TOut }
    NAME        { TName }
    LBRACKET    { TLBracket }
    RBRACKET    { TRBracket }
    BOOLOP      { TBoolOp }
    NUMBER      { TNumber }
    ASS         { TAss }

%%
Expr
  : Lamb               { $1 }
  | App Lamb           { App $1 $2 }
  | App                { $1 }

App
  : App Term       { App $1 $2 }
  | Term           { $1 }

Lamb
  : LAMBDA IDENT DOT Expr  { Lambda $2 $4 }

Term
  : LEFTP Expr RIGHTP  { $2 }
  | IDENT              { Var $1 }

%%
Program
    : BEGIN Body END   { $2 }

Body
    : Body1   { Body $1 }

Body1
    : Operation Body1 { $1 : $2 }
    |                 { [] }

Operation
    : VarDef            { $1 }
    | If                { $1 }
    | Portal            { $1 }
    | In                { $1 }
    | Out               { $1 }
    | Ass               { $1 }

VarDef
    : NAME             { VarDef $1 }

If
    : IF Expr BEGIN Body END { If $2 $4 }

Expr
    : LBRACKET Var BOOLOP Var RBRACKET { Expr $2 $3 $4 }

Portal
    : PORTAL NAME             { Portal $2 }

In
    : IN NAME                 { In $2 }

Out
    : OUT NAME                { "printf(\"$d\"," ++ %2 ++ ");\n" }

Ass
    : Var ASS NAME            { Ass $1 $3 }
    : Var ASS NUMBER          { Ass $1 $3 }

{
    parseError = fail "Parse error"

    data Operation = VarDef String | If Expr [Operation]

    type Body = [Operation]
}