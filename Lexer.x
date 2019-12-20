{
module Lexer where
}

%wrapper "basic"

$digit = 0-9
$alpha = [a-z]

tokens :-

  $white+                    ;
  "#".*                      ;
  "{"                         { \_ -> TBegin}
  "}"                         { \_ -> TEnd }
  "if"                          { \_ -> TIf }
  "else"                       {\_ -> TElse}
  "blue"                        { \_ -> TBlue }
  "orange"                      { \_ -> TOrange }
  "in"                          { \_ -> TIn }
  "out"                         { \_ -> TOut }
  $alpha [$alpha $digit ']*   { \s -> TName s }
  \(                          { \_ -> TLBracket }
  \)                          { \_ -> TRBracket }
  ("=="|"!="|"<"|">")         { \s -> TBoolOp s}
  [\+\*\/\-]                  { \s -> TOp s }
  \=                          { \_ -> TAss }
  $digit+                     { \s -> TNumber s}

{

data Token =
         TBegin
        | TEnd
        | TIf
        | TElse
        | TBlue
        | TOrange
        | TIn
        | TOut
        | TName String
        | TLBracket
        | TRBracket
        | TBoolOp String
        | TOp String
        | TAss
        | TNumber String
           deriving (Show, Eq)
}