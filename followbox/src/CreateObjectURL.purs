module CreateObjectURL where

import Control.Monad.Eff (Eff)
import DOM (DOM)
import DOM.File.Types (Blob)
import Network.HTTP.Affjax (URL)

foreign import createObjectURL :: forall eff. Blob -> Eff (dom :: DOM | eff) URL
