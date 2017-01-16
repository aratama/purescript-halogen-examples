module Guid where

import Control.Monad.Eff (Eff)
import DOM (DOM)

newtype Guid = Guid String

foreign import generateGuid :: forall eff. Eff (dom :: DOM | eff) Guid 
