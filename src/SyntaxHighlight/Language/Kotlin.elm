module SyntaxHighlight.Language.Kotlin exposing (parseTokensReversed)

import Parser exposing (Error, keyword, oneOf, symbol)
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
    [ "Any", "Array"
    , "Boolean", "Char", "String"
    , "Byte", "Short", "Int", "Long"
    , "UByte", "UShort", "UInt", "ULong"
    , "Float", "Double"
    , "BooleanArray", "CharArray", "StringArray"
    , "ByteArray", "ShortArray", "IntArray", "LongArray"
    , "UByteArray", "UShortArray", "UIntArray", "ULongArray"
    , "FloatArray", "DoubleArray"
    , "field", "it"
    ]
  , valueTypeAnnotationOperator = ':'
  , functionTypeAnnotation = symbol ":"
  , typeCheckCastOperator = oneOf [ keyword "as?", keyword "!is" ]
  , typeCheckCastKeywords = Set.fromList [ "as", "is" ]
  , typeReferenceSymbols = oneOf [ symbol "<", symbol ">", symbol "," ]
  , annotation = symbol "@"
  }


parseTokensReversed : String -> Result Error (List Token)
parseTokensReversed = CLikeCommon.parseTokensReversed kotlin