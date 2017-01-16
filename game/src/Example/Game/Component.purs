module Example.Game.Component (ui) where

import Control.Monad.Aff (Aff)
import Data.List (List(..))
import Data.Void (Void)
import Example.Game.Eval (eval)
import Example.Game.Render (render)
import Example.Game.Type (Effects, Query)
import Halogen (Component, component)
import Halogen.HTML.Core (HTML)

ui :: Component HTML Query Void (Aff Effects)
ui = component { render, eval, initialState: { count: 0, start: 0.0, fps: Nil } }

