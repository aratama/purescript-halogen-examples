module RequestAnimationFrame where

import Control.Monad.Aff (Aff, makeAff)
import Control.Monad.Eff (Eff)
import DOM (DOM)
import Data.Unit (Unit, unit)

foreign import requestAnimationFrame :: forall eff. Eff (dom :: DOM | eff) Unit -> Eff (dom :: DOM | eff) Unit


waitForAnimationFrame :: forall eff. Aff (dom :: DOM | eff) Unit
waitForAnimationFrame = makeAff \_ resolve -> requestAnimationFrame (resolve unit)


foreign import now :: forall eff. Eff (dom :: DOM | eff) Number