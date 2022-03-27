module SyntaxHighlight.View exposing (toBlockHtml, toInlineHtml)

import Css exposing
  ( property
  -- Container
  , borderRight2, display, margin, margin4, padding4, position, width
  -- Sizes
  , ch, em, pct, px, zero
  -- Other values
  , absolute, before, inlineBlock, right, solid, textAlign
  )
import Html.Styled as Html exposing (Html, Attribute, text, span, code, div, pre)
import Html.Styled.Attributes exposing (class, css)
import SyntaxHighlight.Model exposing (..)


-- Html


toBlockHtml : Theme -> Maybe Int -> Block -> Html msg
toBlockHtml theme maybeStart lines =
  pre
  [ css [ position absolute, width (pct 100), margin zero, theme.default ]
  , class "elmsh"
  ]
  ( case maybeStart of
      Nothing ->
        List.map (div [] << lineView theme) lines

      Just start ->
        List.indexedMap (numberedLineView theme start (start + List.length lines)) lines
  )


numberedLineView : Theme -> Int -> Int -> Int -> Line -> Html msg
numberedLineView theme start end index { tokens, highlight } =
  div
  ( css
    [ before
      [ property "content" ("\"" ++ (toString (start + index)) ++ "\"")
      , display inlineBlock, width (ch ((logBase 10 (toFloat end)) + 1.5))
      , margin4 zero (em 1) zero zero, padding4 zero (em 0.5) zero zero
      , borderRight2 (px 1) solid
      , textAlign right
      , theme.gutter
      ]
    ]
  ::( case highlight of
        Just highlight -> highlightStyleAttributes theme highlight
        Nothing -> []
    )
  )
  ( tokensView theme tokens )


toInlineHtml : Theme -> Line -> Html msg
toInlineHtml theme line =
  code [ css [ theme.default ], class "elmsh" ] (lineView theme line)


lineView : Theme -> Line -> List (Html msg)
lineView theme {tokens, highlight} =
  case highlight of
    Nothing -> tokensView theme tokens
    Just highlight ->
      [ span
        (highlightStyleAttributes theme highlight)
        (tokensView theme tokens)
      ]


highlightStyleAttributes : Theme -> Highlight -> List (Attribute msg)
highlightStyleAttributes theme highlight =
  case highlight of
    Selection -> [ class "elmsh-sel", css [ theme.selection ] ]
    Addition -> [ class "elmsh-add", css [ theme.addition ] ]
    Deletion -> [ class "elmsh-del", css [ theme.deletion ] ]


tokensView : Theme -> List Token -> List (Html msg)
tokensView theme tokens =
  List.map (tokenView theme) tokens


tokenView : Theme -> Token -> Html msg
tokenView theme (tokenType, text) =
  if tokenType == Normal then Html.text text
  else
    span
    [ css
      [ case tokenType of
          Comment -> theme.comment
          Keyword -> theme.keyword
          DeclarationKeyword -> theme.declarationKeyword
          BuiltIn -> theme.builtIn
          Operator -> theme.operator
          LiteralNumber -> theme.number
          LiteralString -> theme.string
          LiteralKeyword -> theme.literal
          TypeDeclaration -> theme.typeDeclaration
          TypeReference -> theme.typeReference
          FunctionDeclaration -> theme.functionDeclaration
          FunctionReference -> theme.functionReference
          FunctionArgument -> theme.functionArgument
          FieldDeclaration -> theme.fieldDeclaration
          FieldReference -> theme.fieldReference
          Annotation -> theme.annotation
          _ -> theme.default
      ]
    , class (classByTokenType tokenType)
    ]
    [ Html.text text ]


classByTokenType : TokenType -> String
classByTokenType tokenType =
  "elmsh" ++
  ( case tokenType of
      Normal -> ""
      Comment -> "-comm"
      Namespace -> "-ns"
      Keyword -> "-kw"
      DeclarationKeyword -> "-dkw"
      BuiltIn -> "-bltn"
      Operator -> "-op"
      LiteralNumber -> "-num"
      LiteralString -> "-str"
      LiteralKeyword -> "-lit"
      TypeDeclaration -> "-typd"
      TypeReference -> "-typ"
      FunctionDeclaration -> "-fncd"
      FunctionReference -> "-fnc"
      FunctionArgument -> "-arg"
      FieldDeclaration -> "-fldd"
      FieldReference -> "-fld"
      Annotation -> "-ann"
      _ -> ""
  )