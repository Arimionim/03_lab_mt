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
  if                          { \_ -> TIf }
  portal                      { \_ -> TPortal }
  in                          { \_ -> TIn }
  out                         { \_ -> TOut }
  $alpha [$alpha $digit ']*   { \s -> TName s }
  "("                         { \_ -> TLBracket }
  ")"                         { \_ -> TRBracket }
  ["=="\<\>"!="]              { \s -> TBoolOp s}
  \=                          { \_ -> TAss }
  $Digit+                     { \s -> TNumber s}

{

data Token =
        | TBegin
        | TEnd
        | TIf
        | TPortal
        | TIn
        | TOut
        | TName String
        | TLBracket
        | TRBracket
        | TBoolOp String
        | TAss
        | TNumber
           deriving (Show, Eq)
}