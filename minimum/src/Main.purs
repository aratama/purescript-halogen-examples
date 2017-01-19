module Main where

import Control.Applicative (pure)
import Control.Monad.Eff (Eff)
import Data.Identity (Identity(..))
import Data.Unit (Unit, unit)
import Halogen.Aff.Util (runHalogenAff, awaitBody)
import Halogen.Component (component)
import Halogen.Effects (HalogenEffects)
import Halogen.HTML (text)
import Halogen.VDom.Driver (runUI)
import Prelude ((>>=), ($))

main :: Eff (HalogenEffects ()) Unit
main = runHalogenAff $ awaitBody >>= runUI (component {
    render: \_ -> text "",
    eval: \(Identity a) -> pure a,
    initialState: unit
})
