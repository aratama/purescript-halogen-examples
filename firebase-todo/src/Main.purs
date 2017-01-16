module Main where

import Control.Monad.Eff (Eff)
import Prelude (Unit)
import Example.Todo.View.Type (Effects)
import Example.Todo.Main (todoMain)

main :: Eff (Effects ()) Unit
main = todoMain