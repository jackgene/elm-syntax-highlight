module SyntaxHighlight.Theme.GitHub exposing (css, theme)

import Css exposing (rgb)
import Css.Global exposing (Snippet)
import SyntaxHighlight.Style exposing (RequiredStyles, noEmphasis, backgroundColor, textColor)
import SyntaxHighlight.Theme.Type exposing (Theme, toCss)


-- GitHub inspired theme


css : List Snippet
css =
    toCss theme


theme : Theme
theme =
    { requiredStyles = requiredStyles
    }


requiredStyles : RequiredStyles
requiredStyles =
    { default = noEmphasis (rgb 0x24 0x29 0x2e) (rgb 0xff 0xff 0xff)
    , highlight = backgroundColor (rgb 0xff 0xfb 0xdd)
    , addition = backgroundColor (rgb 0xea 0xff 0xea)
    , deletion = backgroundColor (rgb 0xff 0xec 0xec)
    , comment = textColor (rgb 0x96 0x98 0x96)
    , style1 = textColor (rgb 0x00 0x5c 0xc5)
    , style2 = textColor (rgb 0xdf 0x50 0x00)
    , style3 = textColor (rgb 0xd7 0x3a 0x49)
    , style4 = textColor (rgb 0x00 0x86 0xb3)
    , style5 = textColor (rgb 0x63 0xa3 0x5c)
    , style6 = textColor (rgb 0x00 0x5c 0xc5)
    , style7 = textColor (rgb 0x79 0x5d 0xa3)
    }
