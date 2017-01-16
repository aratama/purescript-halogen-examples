module Main where

import Control.Monad.Eff (Eff)
import Halogen (action)
import Halogen.Aff.Util (runHalogenAff, awaitBody)
import Halogen.VDom.Driver (runUI)
import Prelude (Unit, bind, ($))
import Followbox.Type (Effects, Query(Refresh))
import Followbox.Component (followbox)

main :: Eff (Effects ()) Unit
main = runHalogenAff do
    body <- awaitBody
    io <- runUI followbox body
    io.query $ action Refresh