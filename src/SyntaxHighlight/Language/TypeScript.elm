module SyntaxHighlight.Language.TypeScript exposing (parseTokensReversed)

import Parser exposing (Error, keyword, oneOf)
import Set
import SyntaxHighlight.Language.CLikeCommon as CLikeCommon
import SyntaxHighlight.Model exposing (Token, TokenType(..))


javascript : CLikeCommon.Language
javascript =
  { functionDeclarationKeyword = "function"
  , keywords =
    Set.fromList
    -- JavaScript
    [ "break"
    , "case"
    , "catch"
    , "continue"
    , "debugger"
    , "default"
    , "delete"
    , "do"
    , "else"
    , "enum"
    , "export"
    , "extends"
    , "finally"
    , "for"
    , "if"
    , "implements"
    , "import"
    , "in"
    , "instanceof"
    , "interface"
    , "new"
    , "package"
    , "private"
    , "protected"
    , "public"
    , "return"
    , "switch"
    , "this"
    , "throw"
    , "try"
    , "typeof"
    , "void"
    , "while"
    , "with"
    , "yield"
    -- TypeScript
    , "as"
    , "export"
    , "from"
    , "import"
    , "readonly"
    ]
  , declarationKeywords = Set.fromList [ "var", "const", "let" ]
  , literalKeywords =
    Set.fromList
    [ "true"
    , "false"
    , "null"
    , "undefined"
    , "NaN"
    , "Infinity"
    ]
  , builtIns = Set.fromList [ "bigint", "boolean", "number", "string" ]
  , typeCheckCast = oneOf [ keyword "as", keyword "in" ]
  }


parseTokensReversed : String -> Result Error (List Token)
parseTokensReversed = CLikeCommon.parseTokensReversed javascript
