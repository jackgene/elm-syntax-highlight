module SyntaxHighlight.Language.Kotlin exposing (parseTokensReversed)

import Parser exposing (Error, (|.), keyword, oneOf)
import Set
import SyntaxHighlight.Language.CLikeCommon as CLikeCommon
import SyntaxHighlight.Model exposing (Token, TokenType(..))


kotlin : CLikeCommon.Language
kotlin =
  { functionDeclarationKeyword = "fun"
  , keywords =
    Set.fromList
    [ "as"
    , "as?"
    , "break"
    , "by"
    , "catch"
    , "constructor"
    , "continue"
    , "delegate"
    , "do"
    , "dynamic"
    , "else"
    , "field"
    , "file"
    , "for"
    , "get"
    , "if"
    , "import"
    , "in", "!in"
    , "inint"
    , "interface"
    , "is", "!is"
    , "object"
    , "param"
    , "private"
    , "property"
    , "protected"
    , "public"
    , "receiver"
    , "return"
    , "static"
    , "set"
    , "setparam"
    , "super"
    , "this"
    , "throw"
    , "try"
    , "typealias"
    , "typeof"
    , "val"
    , "value"
    , "var"
    , "when"
    , "where"
    , "while"
    ]
  , declarationKeywords = Set.fromList [ "val", "var"
    -- Remove
    , "class", "data", "abstract", "enum", "import", "protocol", "struct", "package"
    , "actual", "annotation", "companion", "const", "crossinline", "expect", "external", "final", "infix"
    , "inline", "inner", "internal", "lateinit", "noinline", "open", "operator", "out", "override", "reified"
    , "sealed", "suspend", "tailrec", "vararg"
    ]
  , literalKeywords =
    Set.fromList [ "true", "false", "null" ]
  , builtIns =
    Set.fromList
    [ "Bool", "Character", "String"
    , "Int", "Int8", "Int16", "Int32", "Int64"
    , "UInt", "UInt8", "UInt16", "UInt32", "UInt64"
    , "Float", "Double"
    , "field", "it"
    ]
  , typeCheckCast = oneOf [ keyword "as?", keyword "as!", keyword "as", keyword "is" ]
  }


parseTokensReversed : String -> Result Error (List Token)
parseTokensReversed = CLikeCommon.parseTokensReversed kotlin
