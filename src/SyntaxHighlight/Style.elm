module SyntaxHighlight.Style exposing (..)

{-
   The common uses of the styles are the following:

     - **Default**: Default style
     - **Comment**: Comment
     - **Style1**: Number
     - **Style2**: Literal string, attribute value
     - **Style3**: Keyword, tag, operator symbol (=+-*/...)
     - **Style4**: Keyword, group symbol ({}(),)
     - **Style5**: Function, attribute name
     - **Style6**: Literal keyword
     - **Style7**: Argument, parameter
-}

import Css exposing (Color, Style, fontStyle, fontWeight)
import Css.Global exposing (Snippet, class)


type Required
    = Default
    | Comment
    | Style1
    | Style2
    | Style3
    | Style4
    | Style5
    | Style6
    | Style7


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



-- To Css string helpers


toCss : List ( String, Style ) -> List Snippet
toCss classes =
    List.map
    ( \(name, style) -> class name [ style ] )
    classes
