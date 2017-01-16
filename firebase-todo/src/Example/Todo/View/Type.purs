module Example.Todo.View.Type where

import Control.Monad.Eff.Console (CONSOLE)
import Control.Monad.Eff.Random (RANDOM)
import Example.Todo.Model.Type (Model, TaskId)
import Halogen (HalogenEffects)
import Network.HTTP.Affjax (AJAX)
import Web.Firebase (FIREBASE, Firebase, Reference)

type State = {
    firebase :: Firebase,
    connection :: Connection
}

data Connection = NoConnection
                | Connecting
                | Connected Connected

type Connected = {
    reference :: Reference,
    model :: Model
}

data Query a
    = Connect a
    | Disconnect a
    | ToggleCompleted TaskId a
    | UpdateDescription TaskId String a
    | Newtask a
    | RemoveTask TaskId a

type Effects eff = HalogenEffects (
    ajax :: AJAX,
    random :: RANDOM,
    firebase :: FIREBASE,
    console :: CONSOLE | eff)

