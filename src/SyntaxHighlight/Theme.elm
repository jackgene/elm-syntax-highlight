module SyntaxHighlight.Theme
    exposing
        ( all
        , monokai
        , gitHub
        , oneDark
        )

import Css.Global exposing (Snippet)
import SyntaxHighlight.Theme.Monokai as Monokai
import SyntaxHighlight.Theme.GitHub as GitHub
import SyntaxHighlight.Theme.OneDark as OneDark


-- Add all themes name and code here to show in the Demo and Themes page


all : List ( String, List Snippet )
all =
    [ ( "Monokai", monokai )
    , ( "GitHub", gitHub )
    , ( "One Dark", oneDark )
    ]


monokai : List Snippet
monokai =
    Monokai.css


gitHub : List Snippet
gitHub =
    GitHub.css


oneDark : List Snippet
oneDark =
    OneDark.css
