module SyntaxHighlight.Line exposing (highlightLines)

{-| A parsed highlighted line.

## Helpers

@docs highlightLines

-}

import SyntaxHighlight.Model exposing (..)


highlightLines : Highlight -> Int -> Int -> Block -> Block
highlightLines highlight start end lines =
  let
    length =
      List.length lines

    adjStart =
      if start >= 0 then start
      else length + start

    adjEnd =
      if end >= 0 then end
      else length + end
  in
  List.indexedMap (highlightLinesHelp highlight adjStart adjEnd) lines


highlightLinesHelp : Highlight -> Int -> Int -> Int -> Line -> Line
highlightLinesHelp highlight start end index line =
  if index < start || index >= end then line
  else { line | highlight = Just highlight }
