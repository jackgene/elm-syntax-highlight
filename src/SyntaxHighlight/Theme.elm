module SyntaxHighlight.Theme exposing (..)

import Css.Global exposing (class, global)
import Html.Styled exposing (Html)
import SyntaxHighlight.Model exposing (Theme)
import SyntaxHighlight.Theme.Darcula as Darcula
import SyntaxHighlight.Theme.Monokai as Monokai
import SyntaxHighlight.Theme.GitHub as GitHub
import SyntaxHighlight.Theme.OneDark as OneDark


darcula : Theme
darcula = Darcula.theme


monokai : Theme
monokai = Monokai.theme


gitHub : Theme
gitHub = GitHub.theme


oneDark : Theme
oneDark = OneDark.theme




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
  global
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
