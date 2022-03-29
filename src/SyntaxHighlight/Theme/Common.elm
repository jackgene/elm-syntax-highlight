module SyntaxHighlight.Theme.Common exposing (..)

import Css exposing
  ( Color, Style, property
  -- Container
  , borderBottom3, bottom, left, paddingBottom, position, width
  -- Content
  , fontStyle, fontWeight, textDecoration3
  -- Scalars
  , ch, pct
  -- Other values
  , absolute, after, dotted, lineThrough, solid
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


strikeThrough : Color -> Style -> Style
strikeThrough color style =
  Css.batch
  [ style
  , textDecoration3 lineThrough solid color
  ]


squigglyUnderline : Color -> Style -> Style
squigglyUnderline color style =
  Css.batch
  [ borderBottom3 (ch 0.25) dotted color
  , paddingBottom (ch 0.05)
  , after
    [ property "content" "\"\""
    , position absolute, bottom (ch -0.125), left (ch -0.2)
    , width (pct 100)
    , borderBottom3 (ch 0.25) dotted color
    ]
  , style
  ]
