module SyntaxHighlight.Language exposing (python, typeScript, xml)


import Parser
import SyntaxHighlight.Language.Python as Python
import SyntaxHighlight.Language.TypeScript as TypeScript
import SyntaxHighlight.Language.Xml as Xml
import SyntaxHighlight.Model exposing (..)


{-| Parse Python syntax.
-}
python : String -> Result Parser.Error Block
python = Python.parseTokensReversed >> Result.map reverseAndBreakIntoLines


{-| Parse TypeScript syntax.
-}
typeScript : String -> Result Parser.Error Block
typeScript = TypeScript.parseTokensReversed >> Result.map reverseAndBreakIntoLines


{-| Parse XML syntax.
-}
xml : String -> Result Parser.Error Block
xml = Xml.parseTokensReversed >> Result.map reverseAndBreakIntoLines


reverseAndBreakIntoLines : List Token -> Block
reverseAndBreakIntoLines revTokens =
  let
    (tailLines, headTokens, _) =
      List.foldl
      ( \(token) (lineAccum, tokenAccum, maybeLastTokenType) ->
        case token of
          (LineBreak, _) ->
            ( (tokensToLine tokenAccum) :: lineAccum
            , [ token ]
            , Nothing
            )

          (tokenType, tokenText) as token ->
            if Just tokenType == maybeLastTokenType then
              case tokenAccum of
                -- Concat same syntax sequence to reduce html elements.
                (_, headTokenText) :: tailTokens ->
                  ( lineAccum
                  , (tokenType, tokenText ++ headTokenText) :: tailTokens
                  , maybeLastTokenType
                  )

                _ ->
                  ( lineAccum
                  , token :: tokenAccum
                  , maybeLastTokenType
                  )

            else
              ( lineAccum
              , token :: tokenAccum
              , Just tokenType
              )
      )
      ([], [], Nothing)
      revTokens
  in (tokensToLine headTokens) :: tailLines


tokensToLine : List Token -> Line
tokensToLine tokens =
  { tokens = tokens
  , emphasis = Nothing
  , columnEmphases = []
  }
