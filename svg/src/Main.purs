module Main where

import Control.Applicative (pure)
import Control.Monad.Eff (Eff)
import Data.Function (const)
import Data.Identity (Identity(..))
import Data.Unit (Unit, unit)
import Halogen.Aff.Util (runHalogenAff, awaitBody)
import Halogen.Component (component)
import Halogen.Effects (HalogenEffects)
import Halogen.VDom.Driver (runUI)
import Prelude ((>>=), ($))
import SVG (width, height, fill, svg, rect)

main :: Eff (HalogenEffects ()) Unit
main = runHalogenAff $ awaitBody >>= runUI (component {
    render: const $ svg [] [
        rect [
            width "100",
            height "100",
            fill "blue"
        ] [
        ] 
    ],
    eval: \(Identity a) -> pure a,
    initialState: unit
})
