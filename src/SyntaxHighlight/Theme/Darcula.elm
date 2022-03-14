module SyntaxHighlight.Theme.Darcula exposing (theme)

import Css exposing (rgb)
import SyntaxHighlight.Model exposing (Theme)
import SyntaxHighlight.Theme.Common exposing (..)


-- JetBrains Darcula inspired theme
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
    , style5 = textColor (rgb 0xfe 0xc7 0x6d)
    , style6 = textColor (rgb 0x69 0x96 0xbb)
    , style7 = textColor (rgb 0xa9 0xb7 0xc6)
    }
