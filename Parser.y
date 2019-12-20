{
module Parser where
import Lexer
}

%name      parseExpr
%tokentype { Token }
%error     { parseError }


%token
    BEGIN       { TBegin }
    END         { TEnd }
    IF          { TIf }
    BLUE        { TBlue }
    ORANGE      { TOrange }
    IN          { TIn }
    ELSE        { TElse }
    OUT         { TOut }
    NAME        { TName $$}
    LBRACKET    { TLBracket }
    RBRACKET    { TRBracket }
    EQUAL       { TBoolOp "==" }
    NONEQUAL    { TBoolOp "!=" }
    LESS        { TBoolOp "<" }
    MORE        { TBoolOp ">" }
    NUMBER      { TNumber $$ }
    OP          { TOp $$ }
    ASS         { TAss }

%%
Program
    : BEGIN Body END   { "#include <stdio.h> \nint main() {\nint portal = 0;\n" ++ $2 ++ "return 0;\n}" }

Body
    : Body1   { $1 }

Body1
    : Operation Body1 { $1 ++ $2 }
    |                 { "" }

Operation
    : VarDef            { $1 }
    | If                { $1 }
    | Blue              { $1 }
    | Orange            { $1 }
    | In                { $1 }
    | Out               { $1 }
    | Ass               { $1 }

VarDef
    : NAME             { "int " ++ $1 ++ ";\n" }

If
    : IF Expr BEGIN Body END IfEnd { "if (" ++ $2 ++ ") {\n" ++ $4 ++ "}\n" ++ $6 }

IfEnd
    : ELSE BEGIN Body END           { "else {\n" ++ $3 ++ "}\n" }
    |                               { "" }

Expr
    : LBRACKET Val EQUAL Val RBRACKET { $2 ++ "==" ++ $4 }
    | LBRACKET Val NONEQUAL Val RBRACKET { $2 ++ "!=" ++ $4 }
    | LBRACKET Val LESS Val RBRACKET { $2 ++ "<" ++ $4 }
    | LBRACKET Val MORE Val RBRACKET { $2 ++ ">" ++ $4 }

Blue
    : BLUE NAME             { "goto orange_" ++ $2 ++ ";\n"++
                              "blue_" ++ $2 ++ ":\nportal = portal + 1;\n"}
Orange
    : ORANGE NAME           { "goto blue_" ++ $2 ++ ";\n"++
                              "orange_" ++ $2 ++ ":\nportal = portal + 1;\n"}
In
    : IN NAME                 { "scanf(\"%d\", &" ++ $2 ++ ");\n" }

Out
    : OUT Val                { "printf(\"%d\\n\", " ++ $2 ++ ");\n" }

Ass
    : NAME ASS Val            { $1 ++ "=" ++ $3 ++ ";\n" }

Val
    : NUMBER                   { $1 }
    | NAME                     { $1 }
    | Val OP Val               { $1 ++ $2 ++ $3 }

{
    parseError = fail "Parse error"
}