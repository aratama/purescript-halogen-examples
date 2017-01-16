module Followbox.Component (followbox) where

import Control.Monad.Aff (Aff)
import Data.Void (Void)
import Followbox.Eval (eval)
import Followbox.Render (render)
import Followbox.Type (Effects, Query)
import Halogen (Component, component)
import Halogen.HTML.Core (HTML)

followbox :: forall eff. Component HTML Query Void (Aff (Effects eff))
followbox = component { render, eval, initialState: { display: [], users : [] } }

