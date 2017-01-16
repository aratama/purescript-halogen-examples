module Main where

import Control.Alternative (pure)
import Control.Monad.Eff (Eff)
import Data.Unit (unit)
import Example.Game.Component (ui)
import Example.Game.Type (Effects, Query(..))
import Halogen (action)
import Halogen.Aff.Util (runHalogenAff, awaitBody)
import Halogen.VDom.Driver (runUI)
import Prelude (Unit, bind, ($))

main :: Eff Effects Unit
main = runHalogenAff do
    body <- awaitBody
    io <- runUI ui body
    io.query $ action Gameloop
    pure unit
