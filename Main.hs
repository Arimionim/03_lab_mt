module Main where

import Lexer (alexScanTokens)
import Parser (parseExpr)

main :: IO ()
main = do
  input <- getContents
  putStrLn $ parseExpr (alexScanTokens input)