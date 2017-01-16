module Test where

import Control.Alt (void)
import Control.Monad.Aff (Aff, runAff)
import Control.Monad.Aff.Class (liftAff)
import Control.Monad.Aff.Console (log, logShow)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Class (liftEff)
import Control.Monad.Eff.Console (CONSOLE, errorShow)
import Control.Monad.Eff.Exception (EXCEPTION)
import Control.Monad.Eff.Random (RANDOM)
import Control.Monad.Eff.Timer (TIMER)
import Control.Monad.State (StateT(..), execStateT, put)
import Control.Monad.State.Class (get)
import Control.Monad.State.Trans (lift, runStateT)
import Data.Unit (Unit)
import Main (Query(..), State(..), eval)
import Prelude (pure, bind, unit, (==), ($))
import Test.StrongCheck (assert, assertEq)

type Effects eff = (console :: CONSOLE, timer :: TIMER, random :: RANDOM, err :: EXCEPTION | eff)

main :: forall eff. Eff (Effects eff) Unit
main = void $ runAff errorShow pure $ void do
    execStateT test Initial

test :: forall eff.  StateT State (Aff (Effects eff)) Unit
test = do
    eval (Start unit)
    state <- get
    liftEff $ assert (state == Finish)
    eval (Reset unit)
    state' <- get
    liftEff $ assert (state' == Initial)