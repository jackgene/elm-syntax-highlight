module SyntaxHighlight.Language.TypeScript exposing (parseTokensReversed)

import Set exposing (Set)
import Parser exposing (Parser, oneOf, zeroOrMore, oneOrMore, ignore, symbol, (|.), (|=), source, keep, Count(..), Error, map, andThen, repeat, succeed)
import SyntaxHighlight.Language.Common exposing (Delimiter, isWhitespace, isSpace, isLineBreak, delimited, escapable, isEscapable, addThen)
import SyntaxHighlight.Model exposing (Token, TokenType(..))


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
  , symbol ":"
    |> andThen (\_ -> typeAnnotationLoop)
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
  if n == "function" || n == "static" then
    functionDeclarationLoop
    |> repeat zeroOrMore
    |> consThenRevConcat [ ( DeclarationKeyword, n ) ]
  else if n == "class" || n == "enum" then
    classDeclarationLoop
    |> repeat zeroOrMore
    |> consThenRevConcat [ ( DeclarationKeyword, n ) ]
  else if n == "constructor" then
    functionDeclarationLoop
    |> repeat zeroOrMore
    |> consThenRevConcat [ ( FunctionDeclaration, n ) ]
  else if isKeyword n then
    succeed [ ( Keyword, n ) ]
  else if isDeclarationKeyword n then
    succeed [ ( DeclarationKeyword, n ) ]
  else if isBuiltIn n then
    succeed [ ( BuiltIn, n ) ]
  else if isLiteralKeyword n then
    succeed [ ( LiteralKeyword, n ) ]
  else
    functionEvalLoop n []


functionDeclarationLoop : Parser (List Token)
functionDeclarationLoop =
  oneOf
  [ whitespaceOrComment
  , keep oneOrMore isIdentifierNameChar
    |> map (\name -> [ ( FunctionDeclaration, name ) ])
  , symbol "*"
    |> map (\_ -> [ ( Keyword, "*" ) ])
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
    |> andThen (\_ -> typeAnnotationLoop)
  , keep oneOrMore (\c -> c == ',')
    |> map (\sep -> [ ( Normal, sep ) ])
  ]


functionEvalLoop : String -> List Token -> Parser (List Token)
functionEvalLoop identifier revTokens =
  oneOf
  [ whitespaceOrComment
    |> addThen (functionEvalLoop identifier) revTokens
  , symbol "("
    |> andThen
      ( \_ ->
        succeed
          ((( Normal, "(" ) :: revTokens)
            ++ [ ( FunctionReference, identifier ) ]
          )
      )
  , succeed (revTokens ++ [ ( Normal, identifier ) ])
  ]


classDeclarationLoop : Parser (List Token)
classDeclarationLoop =
  oneOf
  [ whitespaceOrComment
  , keep oneOrMore isIdentifierNameChar
    |> andThen
      (\n ->
        if n == "extends" then
          classExtendsLoop
            |> repeat zeroOrMore
            |> consThenRevConcat [ ( Keyword, n ) ]
        else
          succeed [ ( TypeDeclaration, n ) ]
      )
  ]


classExtendsLoop : Parser (List Token)
classExtendsLoop =
  oneOf
  [ whitespaceOrComment
  , keep oneOrMore isIdentifierNameChar
    |> map (\name -> [ ( Normal, name ) ])
  ]


typeAnnotationLoop : Parser (List Token)
typeAnnotationLoop =
  oneOf
  [ whitespaceOrComment
  , keep oneOrMore isIdentifierNameChar
    |> map
      ( \name ->
        if isBuiltIn name then [ ( BuiltIn, name ) ]
        else [ ( TypeReference, name ) ]
      )
  ]
  |> repeat zeroOrMore
  |> consThenRevConcat [ ( Operator, ":" ) ]


isIdentifierNameChar : Char -> Bool
isIdentifierNameChar c =
  not ( isPunctuaction c || isStringLiteralChar c || isCommentChar c || isWhitespace c )



-- Reserved Words
isKeyword : String -> Bool
isKeyword str = Set.member str keywordSet


keywordSet : Set String
keywordSet =
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


isDeclarationKeyword : String -> Bool
isDeclarationKeyword str = Set.member str declarationKeywordSet


declarationKeywordSet : Set String
declarationKeywordSet =
  Set.fromList [ "var", "const", "let" ]


isBuiltIn : String -> Bool
isBuiltIn str = Set.member str builtInSet


builtInSet : Set String
builtInSet =
  Set.fromList [ "bigint", "boolean", "number", "string" ]


isPunctuaction : Char -> Bool
isPunctuaction c = Set.member c punctuactorSet


punctuactorSet : Set Char
punctuactorSet = Set.union operatorSet groupSet


operatorChar : Parser Token
operatorChar =
  keep oneOrMore isOperatorChar
    |> map (\op -> ( Operator, op ))


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
    |> map (\name -> ( Normal, name ))


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
    [ "true"
    , "false"
    , "null"
    , "undefined"
    , "NaN"
    , "Infinity"
    ]



-- String literal
stringLiteral : Parser (List Token)
stringLiteral =
  oneOf
  [ quote
  , doubleQuote
  , templateString
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
  , innerParsers = [ lineBreakList, jsEscapable ]
  , isNotRelevant = \c -> not (isLineBreak c || isEscapable c)
  }


doubleQuote : Parser (List Token)
doubleQuote =
  delimited
  { quoteDelimiter
    | start = "\""
    , end = "\""
  }


templateString : Parser (List Token)
templateString =
  delimited
  { quoteDelimiter
    | start = "`"
    , end = "`"
    , innerParsers = [ lineBreakList, jsEscapable ]
    , isNotRelevant = \c -> not (isLineBreak c || isEscapable c)
  }


isStringLiteralChar : Char -> Bool
isStringLiteralChar c =
  c == '"' || c == '\'' || c == '`'



-- Comments
comment : Parser (List Token)
comment =
  oneOf
  [ inlineComment
  , multilineComment
  ]


inlineComment : Parser (List Token)
inlineComment =
  symbol "//"
  |. ignore zeroOrMore (not << isLineBreak)
  |> source
  |> map (\c -> [ ( Comment, c ) ])


multilineComment : Parser (List Token)
multilineComment =
  delimited
  { start = "/*"
  , end = "*/"
  , isNestable = False
  , defaultMap = \c -> (Comment, c)
  , innerParsers = [ lineBreakList ]
  , isNotRelevant = \c -> not (isLineBreak c)
  }


isCommentChar : Char -> Bool
isCommentChar c = c == '/'


-- Helpers
whitespaceOrComment : Parser (List Token)
whitespaceOrComment =
  oneOf
  [ keep oneOrMore isSpace
    |> map (\space -> [ ( Normal, space ) ])
  , lineBreakList
  , comment
  ]


lineBreakList : Parser (List Token)
lineBreakList =
  keep (Exactly 1) isLineBreak
  |> map (\c -> ( LineBreak, c ))
  |> repeat oneOrMore


number : Parser Token
number =
  SyntaxHighlight.Language.Common.number
  |> source
  |> map (\num -> ( LiteralNumber, num ))


jsEscapable : Parser (List Token)
jsEscapable =
  escapable
  |> source
  |> map (\c -> ( LiteralKeyword, c ))
  |> repeat oneOrMore


consThenRevConcat : List Token -> Parser (List (List Token)) -> Parser (List Token)
consThenRevConcat toCons =
  map ((::) toCons >> List.reverse >> List.concat)
