module SyntaxHighlight.View exposing (toBlockHtml, toInlineHtml)

import Html.Styled as Html exposing (Html, text, span, code, div, pre)
import Html.Styled.Attributes exposing (class, classList, attribute)
import SyntaxHighlight.Model exposing (..)


-- Html


toBlockHtml : Theme -> Maybe Int -> Block -> Html msg
toBlockHtml theme maybeStart lines =
  pre [ class "elmsh" ]
  ( case maybeStart of
      Nothing ->
        List.map (pre [] << lineView theme) lines

      Just start ->
        List.indexedMap (numberedLineView theme start) lines
  )


numberedLineView : Theme -> Int -> Int -> Line -> Html msg
numberedLineView theme start index { tokens, highlight } =
  pre
  [ classList
      [ ( "elmsh-line", True )
      , ( "elmsh-hl", highlight == Just Selected )
      , ( "elmsh-add", highlight == Just Addition )
      , ( "elmsh-del", highlight == Just Deletion )
      ]
  , attribute "data-elmsh-lc" (toString (start + index))
  ]
  (tokensView theme tokens)


toInlineHtml : Theme -> Line -> Html msg
toInlineHtml theme line =
  code [ class "elmsh" ] (lineView theme line)


lineView : Theme -> Line -> List (Html msg)
lineView theme {tokens, highlight} =
  ( if highlight == Nothing then
      tokensView theme tokens
    else
      [ span
        [ classList
            [ ( "elmsh-hl", highlight == Just Selected )
            , ( "elmsh-add", highlight == Just Addition )
            , ( "elmsh-del", highlight == Just Deletion )
            ]
        ]
        (tokensView theme tokens)
      ]
  )


tokensView : Theme -> List Token -> List (Html msg)
tokensView theme tokens =
  List.map (tokenView theme) tokens


tokenView : Theme -> Token -> Html msg
tokenView theme (tokenType, text) =
  if tokenType == Normal then Html.text text
  else
    span
    [ class (classByToken tokenType) ] -- TODO determine style from theme
    [ Html.text text ]


classByToken : TokenType -> String
classByToken tokenType =
  "elmsh" ++
  ( case tokenType of
      Normal -> "0"
      Comment -> "-comm"
      LiteralNumber -> "1"
      LiteralString -> "2"
      TypeAnnotation -> "3"
      Keyword -> "4"
      DeclarationKeyword -> "4"
      FunctionDeclaration -> "5"
      LiteralKeyword -> "6"
      FunctionParameter -> "7"
      FunctionCall -> "fc"
      Operator -> "op"
      _ -> "42"
  )