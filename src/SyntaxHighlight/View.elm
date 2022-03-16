module SyntaxHighlight.View exposing (toBlockHtml, toInlineHtml)

import Html.Styled as Html exposing (Html, text, span, code, div, pre)
import Html.Styled.Attributes exposing (attribute, class, classList, css)
import SyntaxHighlight.Model exposing (..)


-- Html


toBlockHtml : Theme -> Maybe Int -> Block -> Html msg
toBlockHtml theme maybeStart lines =
  pre [ css [ theme.default ], class "elmsh" ]
  ( case maybeStart of
      Nothing ->
        List.map (pre [] << lineView theme) lines

      Just start ->
        List.indexedMap (numberedLineView theme start) lines
  )


numberedLineView : Theme -> Int -> Int -> Line -> Html msg
numberedLineView theme start index { tokens, highlight } =
  div
  [ classList
      [ ( "elmsh-hl", highlight == Just Selected )
      , ( "elmsh-add", highlight == Just Addition )
      , ( "elmsh-del", highlight == Just Deletion )
      ]
  , attribute "data-elmsh-lc" (toString (start + index)) -- TODO line number using elm-css
  ]
  (tokensView theme tokens)


toInlineHtml : Theme -> Line -> Html msg
toInlineHtml theme line =
  code [ css [ theme.default ], class "elmsh" ] (lineView theme line)


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
    [ css
      [ case tokenType of
          Comment -> theme.comment
          Keyword -> theme.keyword
          DeclarationKeyword -> theme.declarationKeyword
          Operator -> theme.operator
          LiteralNumber -> theme.number
          LiteralString -> theme.string
          LiteralKeyword -> theme.literal
          TypeDeclaration -> theme.typeDeclaration
          TypeReference -> theme.typeReference
          FunctionDeclaration -> theme.functionDeclaration
          FunctionReference -> theme.functionReference
          FunctionArgument -> theme.functionArgument
          FieldName -> theme.field
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
      Keyword -> "-kw"
      DeclarationKeyword -> "-dkw"
      Operator -> "-op"
      LiteralNumber -> "-num"
      LiteralString -> "-str"
      LiteralKeyword -> "-lit"
      TypeDeclaration -> "-typd"
      TypeReference -> "-typ"
      FunctionDeclaration -> "-fncd"
      FunctionReference -> "-fnc"
      FunctionArgument -> "-arg"
      FieldName -> "-fld"
      Annotation -> "-ann"
      _ -> ""
  )