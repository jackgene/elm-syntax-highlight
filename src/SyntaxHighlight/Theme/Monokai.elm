module SyntaxHighlight.Theme.Monokai exposing (theme)

import Css exposing (rgb)
import SyntaxHighlight.Model exposing (Theme)
import SyntaxHighlight.Theme.Common exposing (..)


-- Monokai inspired theme
theme : Theme
theme =
    { default = noEmphasis (rgb 0xf8 0xf8 0xf2) (rgb 0x23 0x24 0x1f)
    , highlight = backgroundColor (rgb 0x34 0x34 0x34)
    , addition = backgroundColor (rgb 0x00 0x38 0x00)
    , deletion = backgroundColor (rgb 0x38 0x00 0x00)
    , comment = textColor (rgb 0x75 0x71 0x5e)
    , style1 = textColor (rgb 0xae 0x81 0xff)
    , style2 = textColor (rgb 0xe6 0xdb 0x74)
    , style3 = textColor (rgb 0xf9 0x26 0x72)
    , style4 = textColor (rgb 0x66 0xd9 0xef)
    , style5 = textColor (rgb 0xa6 0xe2 0x2e)
    , style6 = textColor (rgb 0xae 0x81 0xff)
    , style7 = textColor (rgb 0xfd 0x97 0x1f)
    }
