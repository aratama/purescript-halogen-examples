module Example.Game.Eval (eval) where

import Control.Monad.Aff (Aff)
import Control.Monad.Rec.Class (forever)
import Data.Functor ((<$))
import Data.Int (toNumber)
import Data.List ((:))
import Data.Void (Void)
import Example.Game.Type (State, Query(..), Effects)
import Halogen (ComponentDSL, liftEff, modify)
import Halogen.Query (get, lift)
import Prelude (type (~>), bind, (*), (+), (-), (/), (<))
import RequestAnimationFrame (waitForAnimationFrame, now)

numberOfUsers :: Int
numberOfUsers = 3

eval :: Query ~> ComponentDSL State Query Void (Aff Effects)

eval (Gameloop next) = next <$ forever do
    lift waitForAnimationFrame
    time <- liftEff now
    state <- get
    let delta = time - state.start
    if 1000.0 < delta
        then do
            modify \s -> s {
                count = 0,
                start = time,
                fps = toNumber s.count / delta * 1000.0 : s.fps
            }
        else modify \s -> s { count = state.count + 1 }
