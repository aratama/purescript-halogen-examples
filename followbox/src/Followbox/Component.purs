module Followbox.Component (followbox) where

import Control.Monad.Aff (Aff)
import Data.Void (Void)
import Data.Maybe (Maybe(..))
import Followbox.Eval (eval)
import Followbox.Render (render)
import Followbox.Type (Effects, Query)
import Halogen (Component, component)
import Halogen.HTML.Core (HTML)
import Prelude(Unit, const)

followbox :: forall eff. Component HTML Query Unit Void (Aff (Effects eff))
followbox = component { render
                      , eval
                      , initialState: const { display: [], users : [] }
                      , receiver: const Nothing
                      }
