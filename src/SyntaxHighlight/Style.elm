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
