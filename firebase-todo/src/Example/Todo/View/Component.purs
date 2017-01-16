module Example.Todo.View.Component (ui) where

import Control.Monad.Aff (Aff)
import Data.Void (Void)
import Example.Todo.View.Eval (eval)
import Example.Todo.View.Render (render)
import Example.Todo.View.Type (Connection(NoConnection), Effects, Query)
import Halogen (Component, component)
import Halogen.HTML.Core (HTML)
import Web.Firebase (Firebase)

ui :: forall eff. Firebase -> Component HTML Query Void (Aff (Effects eff))
ui firebase = component {
    render,
    eval,
    initialState: {
        firebase,
        connection: NoConnection
    }
}

