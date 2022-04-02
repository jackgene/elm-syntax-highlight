module SyntaxHighlight.Language.CLikeCommon exposing (Language, parseTokensReversed)

import Set exposing (Set)
import Parser exposing
  ( Count(..), Error, Parser
  , (|.), (|=), andThen, ignore, keep, map, oneOf, oneOrMore
  , repeat, source, succeed, symbol, zeroOrMore
  )
import SyntaxHighlight.Language.Common exposing
  ( Delimiter, isWhitespace, isSpace, isLineBreak, delimited, escapable
  , isEscapable, addThen, consThenRevConcat
  )
import SyntaxHighlight.Model exposing (Token, TokenType(..))


type alias Language =
  { functionDeclarationKeyword : String
  , keywords : Set String
  , declarationKeywords : Set String
  , literalKeywords : Set String
  , builtIns : Set String
  , typeCheckCastOperator : Parser ()
  , typeCheckCastKeywords : Set String
  , annotation : Parser ()
  }


-- TODO type - casting vs annotation
-- TODO parse namespage
-- TODO field declaration, reference
parseTokensReversed : Language -> String -> Result Error (List Token)
parseTokensReversed opt =
  Parser.run
  ( map
    ( List.reverse >> List.concat )
    ( repeat zeroOrMore (mainLoop opt) )
  )


mainLoop : Language -> Parser (List Token)
mainLoop opt =
  oneOf
  [ whitespaceOrComment
  , stringLiteral
  , opt.annotation
    |> source
    |> andThen annotationLoop
  , opt.typeCheckCastOperator
    |> source
    |> andThen (typeReferenceLoop opt)
  , oneOf
    [ operatorChar
    , groupChar
    , number
    ]
    |> map List.singleton
  , keep oneOrMore isIdentifierNameChar
    |> andThen (keywordParser opt)
  ]


keywordParser : Language -> String -> Parser (List Token)
keywordParser opt n =
  if n == opt.functionDeclarationKeyword then
    functionDeclarationLoop opt
    |> repeat zeroOrMore
    |> consThenRevConcat [ ( DeclarationKeyword, n ) ]
  else if n == "class" || n == "enum" then
    classDeclarationLoop
    |> repeat zeroOrMore
    |> consThenRevConcat [ ( DeclarationKeyword, n ) ]
  else if n == "constructor" then
    functionDeclarationLoop opt
    |> repeat zeroOrMore
    |> consThenRevConcat [ ( FunctionDeclaration, n ) ]
  else if Set.member n opt.typeCheckCastKeywords then
    typeReferenceLoop opt n
  else if Set.member n opt.keywords then
    succeed [ ( Keyword, n ) ]
  else if Set.member n opt.declarationKeywords then
    succeed [ ( DeclarationKeyword, n ) ]
  else if Set.member n opt.literalKeywords then
    succeed [ ( LiteralKeyword, n ) ]
  else if Set.member n opt.builtIns then
    succeed [ ( BuiltIn, n ) ]
  else
    variableOrfunctionReferenceLoop n []


functionDeclarationLoop : Language -> Parser (List Token)
functionDeclarationLoop opt =
  oneOf
  [ whitespaceOrComment
  , keep oneOrMore isIdentifierNameChar
    |> map ( \name -> [ ( FunctionDeclaration, name ) ] )
  , symbol "*"
    |> map ( \_ -> [ ( Keyword, "*" ) ] )
  , symbol "("
    |> andThen
      ( \_ ->
        argLoop opt
          |> repeat zeroOrMore
          |> consThenRevConcat [ ( Normal, "(" ) ]
      )
  ]


argLoop : Language -> Parser (List Token)
argLoop opt =
  oneOf
  [ whitespaceOrComment
  , keep oneOrMore (\c -> not (isCommentChar c || isWhitespace c || c == ':' || c == ',' || c == ')'))
    |> map (\name -> [ ( FunctionArgument, name ) ])
  , symbol ":"
    |> source
    |> andThen (typeReferenceLoop opt)
  , keep oneOrMore (\c -> c == ',')
    |> map (\sep -> [ ( Normal, sep ) ])
  ]


variableOrfunctionReferenceLoop : String -> List Token -> Parser (List Token)
variableOrfunctionReferenceLoop identifier revTokens =
  oneOf
  [ whitespaceOrComment
    |> addThen (variableOrfunctionReferenceLoop identifier) revTokens
  , symbol "("
    |> andThen
      ( \_ ->
        succeed
        ( ( ( Normal, "(" ) :: revTokens )
        ++[ ( FunctionReference, identifier ) ]
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
      ( \n ->
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


-- TODO Arrays/Dicts? Swift: `as? [Date]`, Go: `as []time.Time`
-- TODO Keywords after? Swift: `guard x = y as? Date else ...`
typeReferenceLoop : Language -> String -> Parser (List Token)
typeReferenceLoop opt op =
  oneOf
  [ keep oneOrMore isSpace
    |> map ( \c -> [ ( Normal, c ) ] )
  , keep oneOrMore isIdentifierNameChar
    |> map
      ( \name ->
        if Set.member name opt.builtIns then [ ( BuiltIn, name ) ]
        else [ ( TypeReference, name ) ]
      )
  ]
  |> repeat zeroOrMore
  |> consThenRevConcat [ ( if Set.member op opt.keywords then Keyword else Operator, op ) ]


annotationLoop : String -> Parser (List Token)
annotationLoop at =
  keep oneOrMore isIdentifierNameChar
  |> map ( \annotation -> [ ( Annotation, at ++ annotation) ] )


isIdentifierNameChar : Char -> Bool
isIdentifierNameChar c =
  not ( isPunctuaction c || isStringLiteralChar c || isCommentChar c || isWhitespace c )


-- Reserved Words
isPunctuaction : Char -> Bool
isPunctuaction c = Set.member c punctuactorSet


punctuactorSet : Set Char
punctuactorSet = Set.union operatorSet groupSet


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
  |> map ( \c -> ( Normal, c ) )


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
  , defaultMap = \c -> ( Comment, c )
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
  keep ( Exactly 1 ) isLineBreak
  |> map ( \c -> ( LineBreak, c ) )
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
  |> map ( \c -> ( LiteralKeyword, c ) )
  |> repeat oneOrMore
