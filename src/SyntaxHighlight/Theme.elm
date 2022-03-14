module SyntaxHighlight.Theme exposing (..)

import SyntaxHighlight.Model exposing (Theme)
import SyntaxHighlight.Theme.Darcula as Darcula
import SyntaxHighlight.Theme.Monokai as Monokai
import SyntaxHighlight.Theme.GitHub as GitHub
import SyntaxHighlight.Theme.OneDark as OneDark


darcula : Theme
darcula = Darcula.theme


monokai : Theme
monokai = Monokai.theme


gitHub : Theme
gitHub = GitHub.theme


oneDark : Theme
oneDark = OneDark.theme
