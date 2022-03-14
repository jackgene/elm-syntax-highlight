module SyntaxHighlight
    exposing
        ( toBlockHtml, toInlineHtml
        , useTheme
        , Highlight, highlightLines
        )

{-| Syntax highlighting in Elm.

## Html view

@docs toBlockHtml, toInlineHtml


## Helpers

@docs Highlight, highlightLines


## Languages

Error while parsing should not happen. If it happens, please [open an issue](https://github.com/pablohirafuji/elm-syntax-highlight/issues) with the code that gives the error and the language.

@docs css, elm, javascript, python, xml


## Themes

@docs useTheme

-}

import Css.Global exposing (Snippet, class)
import Html.Styled exposing (Html)
import SyntaxHighlight.Model as Model exposing (Theme)
import SyntaxHighlight.View as View
--import SyntaxHighlight.Language.Elm as Elm
--import SyntaxHighlight.Language.Xml as Xml
--import SyntaxHighlight.Language.Css as Css
--import SyntaxHighlight.Language.Python as Python
import SyntaxHighlight.Theme as Theme


type alias Block = Model.Block
type alias Line = Model.Line
type alias Highlight = Model.Highlight


{-| Transform a highlighted code into a Html block.
The `Maybe Int` argument is for showing or not line count and, if so, starting from what number.
-}
toBlockHtml : Model.Theme -> Maybe Int -> Block -> Html msg
toBlockHtml theme maybeStart lines =
    View.toBlockHtml theme maybeStart lines


{-| Transform a highlighted code into inline Html.

    import SyntaxHighlight exposing (elm, toInlineHtml)

    info : Html msg
    info =
        p []
            [ text "This function signature "
            , elm "isEmpty : String -> Bool"
                |> Result.map toInlineHtml
                |> Result.withDefault
                    (code [] [ text "isEmpty : String -> Bool" ])
            , text " means that a String argument is taken, then a Bool is returned."
            ]

-}
toInlineHtml : Model.Theme -> Line -> Html msg
toInlineHtml theme line =
    View.toInlineHtml theme line


{-| Transform a theme into Html. Any highlighted code transformed into Html in the same page will be themed according to the chosen `Theme`.

To preview the themes, check out the [demo](https://pablohirafuji.github.io/elm-syntax-highlight/).

    import SyntaxHighlight exposing (useTheme, monokai, elm, toBlockHtml)

    view : Model -> Html msg
    view model =
        div []
            [ useTheme monokai
            , elm model.elmCode
                |> Result.map (toBlockHtml (Just 1))
                |> Result.withDefault
                    (pre [] [ code [] [ text model.elmCode ] ])
            ]

If you prefer to use CSS external stylesheet, you do **not** need this,
just copy the theme CSS into your stylesheet.
All themes can be found [here](https://pablohirafuji.github.io/elm-syntax-highlight/themes.html).

-}
useTheme : Theme -> Html msg
useTheme theme =
  Css.Global.global
  ( List.map
    ( \(name, style) -> class name [ style ] )
    [ ( "elmsh", theme.default )
    , ( "elmsh-hl", theme.highlight )
    , ( "elmsh-add", theme.addition )
    , ( "elmsh-del", theme.deletion )
    , ( "elmsh-comm", theme.comment )
    , ( "elmsh1", theme.style1 )
    , ( "elmsh2", theme.style2 )
    , ( "elmsh3", theme.style3 )
    , ( "elmsh4", theme.style4 )
    , ( "elmsh5", theme.style5 )
    , ( "elmsh6", theme.style6 )
    , ( "elmsh7", theme.style7 )
    ]
  )


{-| Highlight lines given a highlight type, start and end index.
If no highlight type is given (`Nothing`), it will remove any
highlight from the line range.
Negative indexes are taken starting from the *end* of the list.
-}
highlightLines : Maybe Highlight -> Int -> Int -> Block -> Block
highlightLines maybeHighlight start end lines = lines -- TODO no-op for now, fix
    --let
    --    maybeHighlight_ =
    --        case maybeHighlight of
    --            Nothing ->
    --                Nothing
    --
    --            Just Highlight ->
    --                Just Line.Normal
    --
    --            Just Add ->
    --                Just Line.Add
    --
    --            Just Del ->
    --                Just Line.Del
    --in
    --    Line.highlightLines maybeHighlight_ start end lines
