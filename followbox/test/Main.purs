module Test.Main where

import Control.Alternative (pure)
import Control.Bind (bind)
import Control.Monad.Aff (Canceler, runAff)
import Control.Monad.Aff.Console (log, logShow)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, errorShow)
import GithubAPI (fetchUsers)
import Network.HTTP.Affjax (AJAX)
import Prelude (discard)

main :: Eff (console :: CONSOLE, ajax :: AJAX) (Canceler (console :: CONSOLE, ajax :: AJAX))
main = runAff errorShow pure do
    log "いまから取りに行くよ！"
    users <- fetchUsers 42
    log "とれたよ！"
    logShow users
