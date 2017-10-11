module Followbox.Type where

import Control.Monad.Eff.Random (RANDOM)
import Data.Maybe (Maybe)
import Data.Tuple (Tuple)
import GithubAPI (User)
import Halogen.Aff.Effects (HalogenEffects)
import Network.HTTP.Affjax (AJAX, URL)

type State = {
    display :: Array (Maybe (Tuple User URL)),
    users :: Array User
}

data Query a = Refresh a
             | Close String a

type Effects eff = HalogenEffects (ajax :: AJAX, random :: RANDOM | eff)

