module SyntaxHighlight.Theme.Common exposing (..)

import Css exposing (Color, Style, fontStyle, fontWeight)
import Css.Global exposing (Snippet, class)


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


noEmphasis : Color -> Color -> Style
noEmphasis text background = Css.batch [ textColor text, backgroundColor background ]


textColor : Color -> Style
textColor text = Css.color text


backgroundColor : Color -> Style
backgroundColor background = Css.backgroundColor background


italic : Style -> Style
italic style = Css.batch [ style, fontStyle Css.italic ]


bold : Style -> Style
bold style = Css.batch [ style, fontWeight Css.bold ]


toCss : Theme -> List Snippet
toCss theme =
  List.map
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
