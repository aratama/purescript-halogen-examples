module Example.Todo.View.Type where

import Control.Monad.Eff.Console (CONSOLE)
import Control.Monad.Eff.Random (RANDOM)
import Data.Foreign (Foreign)
import Example.Todo.Model.Type (Model, TaskId)
import Halogen (HalogenEffects)
import Halogen.Query.EventSource (SubscribeStatus)
import Network.HTTP.Affjax (AJAX)
import Web.Firebase (FIREBASE, Firebase, Reference, Snapshot)

type State = {
    firebase :: Firebase,
    connection :: Connection
}

data Connection = NoConnection
                | Connecting Reference
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
    | HandleValue Snapshot (SubscribeStatus -> a)

type Effects eff = HalogenEffects (
    ajax :: AJAX,
    random :: RANDOM,
    firebase :: FIREBASE,
    console :: CONSOLE | eff)

