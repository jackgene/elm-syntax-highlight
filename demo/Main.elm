module Main exposing (..)

import Css exposing
  ( Style, absolute, bottom, em, fontFamily, fontSize, height, left, margin2
  , overflow, pc, position, rgb, right, sansSerif, scroll, top, width, zero
  )
import Dict exposing (Dict)
import Examples exposing (..)
import Html.Styled as Html exposing
  ( Attribute, Html
  , div, fieldset, input, label, legend, option, select, text
  )
import Html.Styled.Attributes exposing (checked, css, selected, type_, value)
import Html.Styled.Events exposing (on, onCheck, targetValue)
import Http exposing (decodeUri)
import Json.Decode as Json
import Navigation exposing (Location)
import Parser
import Regex exposing (HowMany(..), regex)
import Set exposing (Set)
import SyntaxHighlight.Model exposing (Block, Theme)
import SyntaxHighlight exposing (toBlockHtml)
import SyntaxHighlight.Language as Language
import SyntaxHighlight.Theme as Theme
import SyntaxHighlight.Theme.Common exposing
  ( bold, noEmphasis, noStyle, textColor )


-- Model
type alias SourceCode =
  { language : String
  , text : String
  , parser : String -> Result Parser.Error Block
  }


type alias NamedTheme =
  { name : String
  , definition : Theme
  }


type alias HighlightedToken =
  { comment : Bool
  , namespace : Bool
  , keyword : Bool
  , declarationKeyword : Bool
  , builtIn : Bool
  , operator : Bool
  , number : Bool
  , string : Bool
  , literal : Bool
  , typeDeclaration : Bool
  , typeReference : Bool
  , functionDeclaration : Bool
  , functionReference : Bool
  , functionArgument : Bool
  , fieldDeclaration : Bool
  , fieldReference : Bool
  , annotation : Bool
  }


type alias Model =
  { sourceCode : SourceCode
  , sourceCodesByLanguage : Dict String SourceCode
  , firstLine : Maybe Int
  , theme : NamedTheme
  , highlightedToken : HighlightedToken
  }


-- Constants
highlightTokensThemeName : String
highlightTokensThemeName = "Highlight Tokens"


darcula : NamedTheme
darcula = NamedTheme "Darcula" Theme.darcula


themesByName : Dict String NamedTheme
themesByName =
  Dict.fromList
  ( List.map
    ( \theme -> (theme.name, theme) )
    [ darcula
    , NamedTheme "GitHub" Theme.gitHub
    , NamedTheme "Monokai" Theme.monokai
    , NamedTheme "OneDark" Theme.oneDark
    ]
  )


defaultTypeScriptSourceCode : SourceCode
defaultTypeScriptSourceCode =
  SourceCode "TypeScript" typeScriptExample Language.typeScript


-- Common
themeByName : HighlightedToken -> String -> Maybe NamedTheme
themeByName highlightedToken name =
  if name /= highlightTokensThemeName then Dict.get name themesByName
  else
    Just
    ( NamedTheme highlightTokensThemeName
      ( tokenHighlightingTheme highlightedToken )
    )


applyHashState : String -> Model -> Model
applyHashState hash model =
  let
    hashParams : Dict String String
    hashParams =
      Dict.fromList
      ( List.filterMap
        ( \eqDelimKeyVal ->
          case Regex.split (AtMost 2) (regex "=") eqDelimKeyVal of
            key :: uriEncodedValue :: _ ->
              Maybe.map
              ( \value -> (key, value) )
              ( decodeUri uriEncodedValue )
            _ -> Nothing
        )
        ( String.split "&" (String.dropLeft 1 hash) )
      )

    tokens : Set String
    tokens =
      Maybe.withDefault Set.empty
      ( Maybe.map
        ( Set.fromList << String.split "|" )
        ( Dict.get "tokens" hashParams )
      )

    highlightedToken : HighlightedToken
    highlightedToken =
      { comment = Set.member "comm" tokens
      , namespace = Set.member "ns" tokens
      , keyword = Set.member "kw" tokens
      , declarationKeyword = Set.member "dkw" tokens
      , builtIn = Set.member "bltn" tokens
      , operator = Set.member "op" tokens
      , number = Set.member "num" tokens
      , string = Set.member "str" tokens
      , literal = Set.member "lit" tokens
      , typeDeclaration = Set.member "typd" tokens
      , typeReference = Set.member "typ" tokens
      , functionDeclaration = Set.member "fncd" tokens
      , functionReference = Set.member "fnc" tokens
      , functionArgument = Set.member "arg" tokens
      , fieldDeclaration = Set.member "fldd" tokens
      , fieldReference = Set.member "fld" tokens
      , annotation = Set.member "ann" tokens
      }

    theme : NamedTheme
    theme =
      Maybe.withDefault darcula
      ( Maybe.andThen
        ( themeByName highlightedToken )
        ( Dict.get "theme" hashParams )
      )
  in
  { model | theme = theme, highlightedToken = highlightedToken }


-- Init
emptyHighlightedToken : HighlightedToken
emptyHighlightedToken =
  HighlightedToken
  False False False False False False False False False
  False False False False False False False False


init : Location -> (Model, Cmd Msg)
init location =
  ( applyHashState location.hash
    { sourceCode = defaultTypeScriptSourceCode
    , sourceCodesByLanguage =
      Dict.fromList
      ( List.map
        ( \code -> (code.language, code) )
        [ SourceCode "CSS" cssExample Language.typeScript
        , SourceCode "Elm" elmExample Language.typeScript
        , SourceCode "Python" pythonExample Language.typeScript
        , defaultTypeScriptSourceCode
        , SourceCode "XML" xmlExample Language.typeScript
        ]
      )
    , firstLine = Just 1
    , theme = darcula
    , highlightedToken = emptyHighlightedToken
    }
  , Cmd.none
  )


-- Update
type Msg
  = NewLocation Location
  | ThemeByName String
  | TokenHighlightingState (HighlightedToken -> Bool -> HighlightedToken) Bool


tokenHighlightingTheme : HighlightedToken -> Theme
tokenHighlightingTheme token =
  let
    highlight : Style
    highlight = bold (textColor (rgb 128 0 0))
  in
  { default = noEmphasis (rgb 144 144 144) (rgb 240 240 240)
  , selection = noStyle
  , addition = noStyle
  , deletion = noStyle
  , comment = if token.comment then highlight else noStyle
  , namespace = if token.namespace then highlight else noStyle
  , keyword = if token.keyword then highlight else noStyle
  , declarationKeyword = if token.declarationKeyword then highlight else noStyle
  , builtIn = if token.builtIn then highlight else noStyle
  , operator = if token.operator then highlight else noStyle
  , number = if token.number then highlight else noStyle
  , string = if token.string then highlight else noStyle
  , literal = if token.literal then highlight else noStyle
  , typeDeclaration = if token.typeDeclaration then highlight else noStyle
  , typeReference = if token.typeReference then highlight else noStyle
  , functionDeclaration = if token.functionDeclaration then highlight else noStyle
  , functionArgument = if token.functionArgument then highlight else noStyle
  , functionReference = if token.functionReference then highlight else noStyle
  , fieldDeclaration = if token.fieldDeclaration then highlight else noStyle
  , fieldReference = if token.fieldReference then highlight else noStyle
  , annotation = if token.annotation then highlight else noStyle
  , other = Dict.empty
  , gutter = noEmphasis (rgb 120 120 120) (rgb 224 224 224)
  }


hashOf : String -> HighlightedToken -> String
hashOf themeName tokens =
  "#theme=" ++ themeName ++
  ( if themeName /= highlightTokensThemeName then ""
    else
      "&tokens=" ++
      ( String.join "|"
        ( ( if tokens.comment then [ "comm" ] else [] )
        ++( if tokens.namespace then [ "ns" ] else [] )
        ++( if tokens.keyword then [ "kw" ] else [] )
        ++( if tokens.declarationKeyword then [ "dkw" ] else [] )
        ++( if tokens.builtIn then [ "bltn" ] else [] )
        ++( if tokens.operator then [ "op" ] else [] )
        ++( if tokens.number then [ "num" ] else [] )
        ++( if tokens.string then [ "str" ] else [] )
        ++( if tokens.literal then [ "lit" ] else [] )
        ++( if tokens.typeDeclaration then [ "typd" ] else [] )
        ++( if tokens.typeReference then [ "typ" ] else [] )
        ++( if tokens.functionDeclaration then [ "fncd" ] else [] )
        ++( if tokens.functionReference then [ "fnc" ] else [] )
        ++( if tokens.functionArgument then [ "arg" ] else [] )
        ++( if tokens.fieldDeclaration then [ "fldd" ] else [] )
        ++( if tokens.fieldReference then [ "fld" ] else [] )
        ++( if tokens.annotation then [ "ann" ] else [] )
        )
      )
  )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    ThemeByName name ->
      ( { model
        | theme = Maybe.withDefault model.theme (themeByName model.highlightedToken name)
        }
      , Navigation.newUrl (hashOf name model.highlightedToken)
      )

    TokenHighlightingState updateHighlightedToken highlight ->
      let
        currentTheme : NamedTheme
        currentTheme = model.theme

        newHighlightedToken : HighlightedToken
        newHighlightedToken = updateHighlightedToken model.highlightedToken highlight
      in
      ( { model
        | highlightedToken = newHighlightedToken
        , theme =
          { currentTheme
          | definition = tokenHighlightingTheme newHighlightedToken
          }
        }
      , Navigation.newUrl (hashOf currentTheme.name newHighlightedToken)
      )

    NewLocation location ->
      ( applyHashState location.hash model
      , Cmd.none
      )


-- View
onChange : (String -> msg) -> Attribute msg
onChange tagger = on "change" (Json.map tagger targetValue)


optionsView : String -> List String -> List (Html Msg)
optionsView current =
  List.map
  ( \item ->
    option
    [ selected (current == item), value item ]
    [ text item ]
  )


--numberInput : String -> Int -> (Int -> Msg) -> Html Msg
--numberInput labelText defaultVal msg =
--  label []
--  [ text labelText
--  , input
--    [ type_ "number"
--    , onInput (String.toInt >> Result.withDefault 0 >> msg)
--    , defaultValue (toString defaultVal)
--    ]
--    []
--  ]


highlightTokenFormFieldView : String -> Bool -> (HighlightedToken -> Bool -> HighlightedToken) -> Html Msg
highlightTokenFormFieldView tokenName currentChecked updateHighlightedToken =
  div []
  [ label []
    [ input
      [ type_ "checkbox"
      , checked currentChecked
      , onCheck (TokenHighlightingState updateHighlightedToken)
      ]
      []
    , text tokenName
    ]
  ]


highlightTokenFormView : HighlightedToken -> Html Msg
highlightTokenFormView tokens =
  fieldset [ css [ margin2 (em 0.5) zero ] ]
  [ legend [] [ text "Tokens to Highlight" ]
  , highlightTokenFormFieldView "Comment" tokens.comment
    ( \tokens value -> { tokens | comment = value } )
  , highlightTokenFormFieldView "Namespace" tokens.namespace
    ( \tokens value -> { tokens | namespace = value } )
  , highlightTokenFormFieldView "Keyword" tokens.keyword
    ( \tokens value -> { tokens | keyword = value } )
  , highlightTokenFormFieldView "Declaration Keyword" tokens.declarationKeyword
    ( \tokens value -> { tokens | declarationKeyword = value } )
  , highlightTokenFormFieldView "Built-In" tokens.builtIn
    ( \tokens value -> { tokens | builtIn = value } )
  , highlightTokenFormFieldView "Operator" tokens.operator
    ( \tokens value -> { tokens | operator = value } )
  , highlightTokenFormFieldView "Number" tokens.number
    ( \tokens value -> { tokens | number = value } )
  , highlightTokenFormFieldView "String" tokens.string
    ( \tokens value -> { tokens | string = value } )
  , highlightTokenFormFieldView "Literal" tokens.literal
    ( \tokens value -> { tokens | literal = value } )
  , highlightTokenFormFieldView "Type Declaration" tokens.typeDeclaration
    ( \tokens value -> { tokens | typeDeclaration = value } )
  , highlightTokenFormFieldView "Type Reference" tokens.typeReference
    ( \tokens value -> { tokens | typeReference = value } )
  , highlightTokenFormFieldView "Function Declaration" tokens.functionDeclaration
    ( \tokens value -> { tokens | functionDeclaration = value } )
  , highlightTokenFormFieldView "Function Reference" tokens.functionReference
    ( \tokens value -> { tokens | functionReference = value } )
  , highlightTokenFormFieldView "Function Argument" tokens.functionArgument
    ( \tokens value -> { tokens | functionArgument = value } )
  , highlightTokenFormFieldView "Field Declaration" tokens.fieldDeclaration
    ( \tokens value -> { tokens | fieldDeclaration = value } )
  , highlightTokenFormFieldView "Field Reference" tokens.fieldReference
    ( \tokens value -> { tokens | fieldReference = value } )
  , highlightTokenFormFieldView "Annotation" tokens.annotation
    ( \tokens value -> { tokens | annotation = value } )
  ]


view : Model -> Html Msg
view model =
  div [ css [ fontFamily sansSerif ] ]
  [ div
    [ css
      [ position absolute
      , top (pc 1), width (pc 16), height (pc 1), left (pc 1)
      ]
    ]
    ( label []
      [ text "Theme: "
      , select [ onChange ThemeByName ]
        (optionsView model.theme.name ((Dict.keys themesByName) ++ [ highlightTokensThemeName ]))
      ]
    ::( if model.theme.name /= highlightTokensThemeName then []
        else [ highlightTokenFormView model.highlightedToken ]
      )
    )
  , div
    [ css
      [ position absolute
      , top (pc 1), right (pc 1), bottom (pc 1), left (pc 18)
      , overflow scroll
      , fontSize (em 1.5)
      ]
    ]
    [ ( Result.withDefault (text "Error")
        ( Result.map
          ( toBlockHtml model.theme.definition (Just 1) )
          ( model.sourceCode.parser model.sourceCode.text )
        )
      )
    ]
  ]


main : Program Never Model Msg
main =
  Navigation.program NewLocation
  { init = init
  , update = update
  , subscriptions = always Sub.none
  , view = Html.toUnstyled << view
  }
