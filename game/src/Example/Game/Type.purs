module Example.Game.Type where

import Control.Monad.Eff.Random (RANDOM)
import Data.List (List)
import Halogen (HalogenEffects)

type State = {
    count :: Int,
    start :: Number,
    fps :: List Number
}

data Query a = Gameloop a

type Effects = HalogenEffects (random :: RANDOM)

