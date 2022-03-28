module SyntaxHighlight.Theme.Common exposing (..)

import Css exposing
  ( Color, Style, property
  -- Container
  , borderBottom3, bottom, left, marginBottom, position, width
  -- Content
  , fontStyle, fontWeight, textDecoration
  -- Scalars
  , pct, px
  -- Other values
  , absolute, after, dotted, lineThrough
  )


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


strikeThrough : Style -> Style
strikeThrough style = Css.batch [ style, textDecoration lineThrough ]


squigglyUnderline : Color -> Style
squigglyUnderline color =
  Css.batch
  [ borderBottom3 (px 2) dotted color
  , marginBottom (px -2)
  , after
    [ property "content" "\"\""
    , position absolute, bottom (px -1), left (px -2)
    , width (pct 100)
    , borderBottom3 (px 2) dotted color
    ]
  ]
