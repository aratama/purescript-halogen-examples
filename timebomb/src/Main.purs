module Main where

import Control.Applicative (pure)
import Control.Bind (class Bind)
import Control.Monad.Aff.Class (class MonadAff)
import Control.Monad.Aff.Wait (wait)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Timer (TIMER)
import Control.Monad.State.Class (class MonadState)
import Data.Eq (class Eq)
import Data.Show (show)
import Data.Time.Duration (Seconds(..))
import Data.Unit (Unit)
import Halogen.Aff.Util (runHalogenAff, awaitBody)
import Halogen.Component (Component, component)
import Halogen.Effects (HalogenEffects)
import Halogen.HTML (text)
import Halogen.HTML.Core (HTML)
import Halogen.HTML.Elements (button, div_)
import Halogen.HTML.Events (input_, onClick)
import Halogen.Query (put)
import Halogen.VDom.Driver (runUI)
import Prelude (bind)

data State = Initial | Count Int | Finish

derive instance eqState :: Eq State

data Query a = Start a | Reset a

ui :: forall m g eff.(MonadAff (timer :: TIMER | eff) m) => Component HTML Query g m
ui = component { render, eval, initialState: Initial }

render :: forall p. State -> HTML p (Query Unit)
render state = case state of
    Initial -> button [onClick (input_ Start)] [text "Start"]
    Count n -> text (show n)
    Finish -> div_ [text "Booom!", button [onClick (input_ Reset)] [text "Reset"]]

eval :: forall m eff a. (Bind m, MonadState State m, MonadAff (timer :: TIMER | eff) m) => Query a -> m a
eval query = case query of
    Start next -> do
        put (Count 3)
        wait (Seconds 1.0)
        put (Count 2)
        wait (Seconds 1.0)
        put (Count 1)
        wait (Seconds 1.0)
        put Finish
        pure next
    Reset next -> do
        put Initial
        pure next

main :: forall eff. Eff (HalogenEffects (timer :: TIMER | eff)) Unit
main = runHalogenAff do
    body <- awaitBody
    runUI ui body
