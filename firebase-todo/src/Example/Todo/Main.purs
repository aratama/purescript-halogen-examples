module Example.Todo.Main where

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Class (liftEff)
import Data.Foreign.Class (read)
import Halogen.Aff.Util (runHalogenAff, awaitBody)
import Halogen.VDom.Driver (runUI)
import Network.HTTP.Affjax (get)
import Prelude (Unit, bind, ($))
import Web.Firebase (initializeApp)

import Example.Todo.View.Component (ui)
import Example.Todo.View.Eval (liftExceptT)
import Example.Todo.View.Type (Effects)

todoMain :: Eff (Effects ()) Unit
todoMain = runHalogenAff do
    body <- awaitBody
    res <- get "firebase.json"
    profile <- liftExceptT $ read res.response
    firebase <- liftEff $ initializeApp profile
    runUI (ui firebase) body
