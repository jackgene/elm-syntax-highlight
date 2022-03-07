module SyntaxHighlight.View exposing (toBlockHtml, toInlineHtml)

import Html.Styled as Html exposing (Html, text, span, code, div, pre)
import Html.Styled.Attributes exposing (class, classList, attribute)
import SyntaxHighlight.Line exposing (..)
import SyntaxHighlight.Style exposing (Required(..))


-- Html


toBlockHtml : Maybe Int -> List Line -> Html msg
toBlockHtml maybeStart lines =
    case maybeStart of
        Nothing ->
            pre [ class "elmsh" ]
                [ toInlineHtml lines ]

        Just start ->
            lines
                |> List.indexedMap (lineView start)
                |> code []
                |> List.singleton
                |> pre [ class "elmsh" ]


lineView : Int -> Int -> Line -> Html msg
lineView start index { fragments, highlight } =
    div
        [ classList
            [ ( "elmsh-line", True )
            , ( "elmsh-hl", highlight == Just Normal )
            , ( "elmsh-add", highlight == Just Add )
            , ( "elmsh-del", highlight == Just Del )
            ]
        , attribute "data-elmsh-lc" (toString (start + index))
        ]
        (List.map fragmentView fragments)


toInlineHtml : List Line -> Html msg
toInlineHtml lines =
    lines
        |> List.map
            (\{ highlight, fragments } ->
                if highlight == Nothing then
                    List.map fragmentView fragments
                else
                    [ span
                        [ classList
                            [ ( "elmsh-hl", highlight == Just Normal )
                            , ( "elmsh-add", highlight == Just Add )
                            , ( "elmsh-del", highlight == Just Del )
                            ]
                        ]
                        (List.map fragmentView fragments)
                    ]
            )
        |> List.concat
        |> code [ class "elmsh" ]


fragmentView : Fragment -> Html msg
fragmentView { text, requiredStyle, additionalClass } =
    if requiredStyle == Default && String.isEmpty additionalClass then
        Html.text text
    else
        span
            [ classList
                [ ( requiredStyleToString requiredStyle
                  , requiredStyle /= Default
                  )
                , ( "elmsh-" ++ additionalClass
                  , additionalClass /= ""
                  )
                ]
            ]
            [ Html.text text ]


requiredStyleToString : Required -> String
requiredStyleToString required =
    (++) "elmsh" <|
        case required of
            Default ->
                "0"

            Comment ->
                "-comm"

            Style1 ->
                "1"

            Style2 ->
                "2"

            Style3 ->
                "3"

            Style4 ->
                "4"

            Style5 ->
                "5"

            Style6 ->
                "6"

            Style7 ->
                "7"
