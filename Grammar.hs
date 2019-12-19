module Grammar where

    import Data.List (intercalate)
    
    data Expr = Lambda String Expr
              | Var String
              | App Expr Expr

    data
    
    instance Show Expr where
      show (Lambda a b)    = "(\\" ++ a ++ "." ++ (show b) ++ ")"
      show (Var name)      = name
      show (App a b)       = "(" ++ (show a) ++ " " ++ (show b) ++ ")"