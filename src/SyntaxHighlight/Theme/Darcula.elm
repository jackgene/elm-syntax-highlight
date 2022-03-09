module SyntaxHighlight.Theme.Darcula exposing (css, theme)

import Css exposing (rgb)
import Css.Global exposing (Snippet)
import SyntaxHighlight.Style exposing (noEmphasis, backgroundColor, textColor)
import SyntaxHighlight.Theme.Common exposing (Theme, toCss)


-- JetBrains Darcula inspired theme


css : List Snippet
css =
    toCss theme


theme : Theme
theme =
    { default = noEmphasis (rgb 0xa9 0xb7 0xc6) (rgb 0x2b 0x2b 0x2b)
    , highlight = backgroundColor (rgb 0x34 0x34 0x34)
    , addition = backgroundColor (rgb 0x00 0x38 0x00)
    , deletion = backgroundColor (rgb 0x38 0x00 0x00)
    , comment = textColor (rgb 0x80 0x80 0x80)
    , style1 = textColor (rgb 0x69 0x96 0xbb)
    , style2 = textColor (rgb 0x6a 0x88 0x59)
    , style3 = textColor (rgb 0xcb 0x79 0x32)
    , style4 = textColor (rgb 0xcb 0x79 0x32)
    , style5 = textColor (rgb 0xa9 0xb7 0xc6)
    , style6 = textColor (rgb 0x69 0x96 0xbb)
    , style7 = textColor (rgb 0xa9 0xb7 0xc6)
    }
