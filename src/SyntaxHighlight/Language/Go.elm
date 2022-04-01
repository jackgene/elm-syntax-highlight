module SyntaxHighlight.Language.Go exposing (parseTokensReversed)

import Parser exposing (Error, symbol)
import Set
import SyntaxHighlight.Language.CLikeCommon as CLikeCommon
import SyntaxHighlight.Model exposing (Token, TokenType(..))


go : CLikeCommon.Language
go =
  { functionDeclarationKeyword = "func"
  , keywords =
    Set.fromList
    [ "break"
    , "case"
    , "chan"
    , "continue"
    , "default"
    , "defer"
    , "else"
    , "fallthrough"
    , "for"
    , "go"
    , "goto"
    , "if"
    , "import"
    , "interface"
    , "map"
    , "package"
    , "range"
    , "return"
    , "select"
    , "struct"
    , "switch"
    ]
  , declarationKeywords = Set.fromList [ "var", "const"
    -- TODO remove
    , "type" ]
  , literalKeywords =
    Set.fromList [ "true", "false", "nil", "iota" ]
  , builtIns =
    Set.fromList
    [ "bool", "byte", "rune", "string"
    , "int", "int8", "int16", "int32", "int64"
    , "uint", "uint8", "uint16", "uint32", "uint64", "uintptr"
    , "float32", "float64", "complex64", "complex128"
    , "append", "cap", "close", "complex", "copy", "delete", "imag", "len"
    , "make", "new", "panic", "print", "println", "real", "recover"
    ]
  , typeCheckCast = symbol ".("
  }


parseTokensReversed : String -> Result Error (List Token)
parseTokensReversed = CLikeCommon.parseTokensReversed go
