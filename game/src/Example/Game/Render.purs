module Example.Game.Render (render) where

import Data.List (take, toUnfoldable)
import Data.Maybe (Maybe(..))
import Example.Game.Type (Query, State)
import Halogen (ComponentHTML)
import Halogen.HTML (div)
import Halogen.HTML.Core (AttrName(AttrName), PropName(PropName))
import Halogen.HTML.Properties (I, IProp, prop)
import Prelude (show, ($), (<#>), (<>))

render :: State -> ComponentHTML Query
render s = div [] [
    div [style """
        display: flex;
        flex-direction: row;
        align-items: flex-end;
        border: solid 1px grey;
        width: 120px;
        height: 60px;
        overflow: hidden;
    """] $ toUnfoldable (take 120 s.fps) <#> \fps -> div [
        style $ """
            width: 1px;
            height: """ <> show fps <> """px;
            flex-shrink: 0.0;
            background-color: grey;
    """
    ] []
]



style :: forall r i. String -> IProp (style :: I | r) i
style = prop (PropName "style") (Just $ AttrName "style")
