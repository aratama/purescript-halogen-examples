module Followbox.Render (render) where

import Data.Maybe (Maybe(Just, Nothing))
import Data.Tuple (Tuple(..))
import Followbox.ClassNames (outer, title, refresh, users, userClass, avator, name, close)
import Followbox.Type (Query(Close, Refresh), State)
import GithubAPI (User(User))
import Halogen (ComponentHTML)
import Halogen.HTML (text, div, span, button, img, a)
import Halogen.HTML.Events (onClick, input_)
import Halogen.HTML.Properties (src, href, class_)
import Network.HTTP.Affjax (URL)
import Prelude (($), (<$>))

render :: State -> ComponentHTML Query
render s = div [class_ outer] [
    div [class_ title] [
        span [] [text "Who to Follow - "],
        button [class_ refresh, onClick $ input_ Refresh] [text "Refresh"]
    ],
    div [class_ users] $ renderUser <$> s.display
]

renderUser :: Maybe (Tuple User URL) -> ComponentHTML Query
renderUser userMaybe = div [class_ userClass] case userMaybe of
    Nothing -> []
    Just (Tuple (User user) url) -> [
        img [class_ avator, src url],
        a [class_ name, href user.html_url] [text user.login],
        button [class_ close, onClick $ input_ $ Close user.login] [text "X"]
    ]

