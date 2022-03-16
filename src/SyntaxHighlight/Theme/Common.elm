module SyntaxHighlight.Theme.Common exposing (..)

import Css exposing (Color, Style, fontStyle, fontWeight)
import Css.Global exposing (Snippet, class)
import SyntaxHighlight.Model exposing (Theme)


noStyle : Style
noStyle = Css.batch []


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
  , ( "elmsh-hl", theme.selection )
  , ( "elmsh-add", theme.addition )
  , ( "elmsh-del", theme.deletion )
  , ( "elmsh-comm", theme.comment )
  , ( "elmsh1", theme.number )
  , ( "elmsh2", theme.string )
  , ( "elmsh3", theme.keyword )
  , ( "elmsh4", theme.declarationKeyword )
  , ( "elmsh5", theme.functionDeclaration )
  , ( "elmsh6", theme.literal )
  , ( "elmsh7", theme.functionArgument )
  ]
