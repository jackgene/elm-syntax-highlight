module SyntaxHighlight.Theme.Darcula exposing (theme)

import Css exposing (Style, rgb)
import SyntaxHighlight.Model exposing (Theme)
import SyntaxHighlight.Theme.Common exposing (..)


-- JetBrains Darcula inspired theme
theme : Theme
theme =
  let
    keyword : Style
    keyword = textColor (rgb 199 119 62)
  in
  { default = noEmphasis (rgb 163 183 198) (rgb 43 43 43)
  , selection = backgroundColor (rgb 50 50 50)
  , addition = backgroundColor (rgb 0x00 0x38 0x00) -- TODO
  , deletion = backgroundColor (rgb 0x38 0x00 0x00) -- TODO
  , comment = textColor (rgb 120 120 120)
  , namespace = textColor (rgb 175 191 126)
  , keyword = keyword
  , declarationKeyword = keyword
  , operator = noStyle
  , number = textColor (rgb 104 151 187)
  , string = textColor (rgb 106 135 89)
  , literal = keyword
  , typeDeclaration = noStyle
  , typeReference = textColor (rgb 111 175 189)
  , functionDeclaration = textColor (rgb 230 177 99)
  , functionArgument = noStyle
  , functionReference = textColor (rgb 176 157 121)
  , field = textColor (rgb 152 118 170)
  , annotation = textColor (rgb 187 181 41)
  }
