module SyntaxHighlight.Theme.Type exposing (..)

import Css exposing (Style)
import Css.Global exposing (Snippet)
import SyntaxHighlight.Style as Style


type alias Theme =
    { default : Style
    , highlight : Style
    , addition : Style
    , deletion : Style
    , comment : Style
    , style1 : Style
    , style2 : Style
    , style3 : Style
    , style4 : Style
    , style5 : Style
    , style6 : Style
    , style7 : Style
    }


toCss : Theme -> List Snippet
toCss theme =
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
        |> Style.toCss
