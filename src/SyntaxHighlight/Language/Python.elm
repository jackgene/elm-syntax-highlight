module SyntaxHighlight.Language.Python exposing (parseTokensReversed)

import Set exposing (Set)
import Parser exposing
  ( Parser, oneOf, zeroOrMore, oneOrMore, ignore, symbol, (|.), (|=), source
  , keep, Count(..), Error, map, andThen, repeat, succeed
  )
import SyntaxHighlight.Language.Common exposing
  ( Delimiter, isWhitespace, isSpace, isLineBreak, delimited, isEscapable
  , addThen, consThenRevConcat
  )
import SyntaxHighlight.Model exposing (Token, TokenType(..))


-- Author: brandly (https://github.com/brandly)
-- TODO field declaration, reference
parseTokensReversed : String -> Result Error (List Token)
parseTokensReversed =
  Parser.run
  ( map
    ( List.reverse >> List.concat )
    ( repeat zeroOrMore mainLoop )
  )


mainLoop : Parser (List Token)
mainLoop =
  oneOf
  [ whitespaceOrComment
  , stringLiteral
  , oneOf [ symbol ":", symbol "->" ]
    |> source
    |> andThen typeAnnotationLoop
  , oneOf
    [ operatorChar
    , groupChar
    , number
    ]
    |> map List.singleton
  , keep oneOrMore isIdentifierNameChar
    |> andThen keywordParser
  ]


keywordParser : String -> Parser (List Token)
keywordParser n =
  if n == "def" then
    functionDeclarationLoop
    |> repeat zeroOrMore
    |> consThenRevConcat [ ( DeclarationKeyword, n ) ]
  else if n == "class" then
    classDeclarationLoop
    |> repeat zeroOrMore
    |> consThenRevConcat [ ( DeclarationKeyword, n ) ]
  else if isKeyword n then
    succeed [ ( Keyword, n ) ]
  else if isBuiltIn n then
    succeed [ ( BuiltIn, n ) ]
  else if isLiteralKeyword n then
    succeed [ ( LiteralKeyword, n ) ]
  else if n == "f" || n == "r" then
    stringLiteral
    |> repeat zeroOrMore
    |> consThenRevConcat [ ( LiteralString, n ) ]
  else
    functionEvalLoop n []


functionDeclarationLoop : Parser (List Token)
functionDeclarationLoop =
  oneOf
  [ whitespaceOrComment
  , keep oneOrMore isIdentifierNameChar
    |> map ( \name -> [ ( FunctionDeclaration, name ) ] )
  , symbol "("
    |> andThen
      ( \_ ->
        argLoop
        |> repeat zeroOrMore
        |> consThenRevConcat [ ( Normal, "(" ) ]
      )
  ]


argLoop : Parser (List Token)
argLoop =
  oneOf
  [ whitespaceOrComment
  , keep oneOrMore (\c -> not (isCommentChar c || isWhitespace c || c == ':' || c == ',' || c == ')'))
    |> map (\name -> [ ( FunctionArgument, name ) ])
  , symbol ":"
    |> source
    |> andThen typeAnnotationLoop
  , keep oneOrMore (\c -> c == ',')
    |> map (\sep -> [ ( Normal, sep ) ])
  ]


functionEvalLoop : String -> List Token -> Parser (List Token)
functionEvalLoop identifier revTokens =
  oneOf
  [ whitespaceOrComment
    |> addThen ( functionEvalLoop identifier ) revTokens
  , symbol "("
    |> andThen
      ( \_ ->
        succeed
        ( ( ( Normal, "(" ) :: revTokens )
        ++[ ( FunctionReference, identifier ) ]
        )
      )
  , succeed ( revTokens ++ [ ( Normal, identifier ) ] )
  ]


classDeclarationLoop : Parser (List Token)
classDeclarationLoop =
  -- TODO: handle base classes
  oneOf
  [ whitespaceOrComment
  , keep oneOrMore isIdentifierNameChar
    |> map (\name -> [ ( TypeDeclaration, name ) ])
  ]


typeAnnotationLoop : String -> Parser (List Token)
typeAnnotationLoop op =
  oneOf
  [ keep oneOrMore isSpace
    |> map ( \c -> [ ( Normal, c ) ] )
  , keep oneOrMore isIdentifierNameChar
    |> map
      ( \name ->
        if isBuiltIn name then [ ( BuiltIn, name ) ]
        else [ ( TypeReference, name ) ]
      )
  ]
  |> repeat zeroOrMore
  |> consThenRevConcat [ ( Operator, op ) ]


isIdentifierNameChar : Char -> Bool
isIdentifierNameChar c =
  not ( isPunctuation c || isStringLiteralChar c || isCommentChar c || isWhitespace c )


spaces : Parser ()
spaces = ignore zeroOrMore ( \c -> c == ' ' )


-- Reserved words
isKeyword : String -> Bool
isKeyword str = Set.member str keywordSet


keywordSet : Set String
keywordSet =
  Set.fromList
  [ "and"
  , "as"
  , "assert"
  , "break"
  , "continue"
  , "del"
  , "elif"
  , "else"
  , "except"
  , "finally"
  , "for"
  , "from"
  , "global"
  , "if"
  , "import"
  , "in"
  , "is"
  , "lambda"
  , "nonlocal"
  , "not"
  , "or"
  , "pass"
  , "raise"
  , "return"
  , "try"
  , "while"
  , "with"
  , "yield"
  ]


isBuiltIn : String -> Bool
isBuiltIn str = Set.member str builtInSet


builtInSet : Set String
builtInSet =
  Set.fromList [ "bool", "dict", "float", "int", "list", "str" ]


isPunctuation : Char -> Bool
isPunctuation c =
  Set.member c punctuationSet


punctuationSet : Set Char
punctuationSet =
  Set.union operatorSet groupSet


operatorChar : Parser Token
operatorChar =
  keep oneOrMore isOperatorChar
  |> map ( \op -> ( Operator, op ) )


isOperatorChar : Char -> Bool
isOperatorChar c =
  Set.member c operatorSet


operatorSet : Set Char
operatorSet =
  Set.fromList
  [ '+'
  , '-'
  , '*'
  , '/'
  , '='
  , '!'
  , '<'
  , '>'
  , '&'
  , '|'
  , '?'
  , '^'
  , ':'
  , '~'
  , '%'
  , '.'
  ]


groupChar : Parser Token
groupChar =
  keep oneOrMore isGroupChar
  |> map (\c -> ( Normal, c ))


isGroupChar : Char -> Bool
isGroupChar c =
  Set.member c groupSet


groupSet : Set Char
groupSet =
  Set.fromList
  [ '{', '}'
  , '(', ')'
  , '[', ']'
  , ',', ';'
  ]


isLiteralKeyword : String -> Bool
isLiteralKeyword str =
  Set.member str literalKeywordSet


literalKeywordSet : Set String
literalKeywordSet =
  Set.fromList
  [ "True"
  , "False"
  , "None"
  ]


-- String
stringLiteral : Parser (List Token)
stringLiteral =
  -- TODO: shortstring | longstring
  oneOf
  [ quote
  , doubleQuote
  ]


quote : Parser (List Token)
quote =
  delimited quoteDelimiter


quoteDelimiter : Delimiter Token
quoteDelimiter =
  { start = "'"
  , end = "'"
  , isNestable = False
  , defaultMap = \c -> ( LiteralString, c )
  -- TODO: escapable chars
  , innerParsers = [ lineBreak ]
  , isNotRelevant = \c -> not (isLineBreak c || isEscapable c)
  }


doubleQuote : Parser (List Token)
doubleQuote =
  delimited
  { quoteDelimiter
  | start = "\""
  , end = "\""
  }


isStringLiteralChar : Char -> Bool
isStringLiteralChar c =
  c == '"' || c == '\''



-- Comments
comment : Parser (List Token)
comment =
  oneOf
  [ inlineComment
  , multilineComment
  ]


inlineComment : Parser (List Token)
inlineComment =
  symbol "#"
  |. ignore zeroOrMore (not << isLineBreak)
  |> source
  |> map ( \c -> [ ( Comment, c ) ] )


multilineComment : Parser (List Token)
multilineComment =
  -- TODO: might not need this at all. just parse as multiline string?
  delimited
  { start = "'''"
  , end = "'''"
  , isNestable = False
  , defaultMap = \c -> (Comment, c)
  , innerParsers = [ lineBreak ]
  , isNotRelevant = \c -> not (isLineBreak c)
  }


isCommentChar : Char -> Bool
isCommentChar c = c == '#'



-- Helpers
whitespaceOrComment : Parser (List Token)
whitespaceOrComment =
  oneOf
  [ keep oneOrMore isSpace
    |> map ( \c -> [ ( Normal, c ) ] )
  , lineBreak
  , comment
  ]


lineBreak : Parser (List Token)
lineBreak =
  keep (Exactly 1) isLineBreak
  |> map ( \c -> ( LineBreak, c ) )
  |> repeat oneOrMore


number : Parser Token
number =
  SyntaxHighlight.Language.Common.number
  |> source
  |> map ( \num -> ( LiteralNumber, num ) )
