module SyntaxHighlight.Model exposing (..)

import Css exposing (Style)


type alias Block = List Line


type alias Line =
  { tokens : List Token
  , highlight : Maybe Highlight
  , errors : List ErrorSpan
  }


type alias Token = ( TokenType, String )


type TokenType
  -- General
  = Normal
  | Comment
  | LineBreak
  -- Programming Language
  | Keyword
  | DeclarationKeyword -- For backward compatibility
  | Operator
  | LiteralNumber
  | LiteralString
  | LiteralKeyword
  | TypeDeclaration
  | TypeReference
  | FunctionDeclaration
  | FunctionReference
  | FunctionArgument
  | FieldName
  | Annotation
  -- Miscellaneous
  | Other String


{-| Highlight type.

  - `Selected` will highlight the line in a way to differentiate it from the rest, like github's yellow background.
  - `Addition` will highlight in a manner that gives the ideia of new content added.
  - `Deleletion` will highlight in a manner that gives the ideia of removed content.

The specific styles will depend on the chosen `Theme`.

-}
type Highlight
    = Selected
    | Addition
    | Deletion


type alias ErrorSpan =
    { start : Int
    , length : Int
    }


type alias Theme =
  { default : Style
  , selection : Style
  , addition : Style
  , deletion : Style
  , comment : Style
  , namespace : Style
  , keyword : Style
  , declarationKeyword : Style
  , operator : Style
  , number : Style
  , string : Style
  , literal : Style
  , typeDeclaration : Style
  , typeReference : Style
  , functionDeclaration : Style
  , functionReference : Style
  , functionArgument : Style
  , field : Style
  , annotation : Style
  }
