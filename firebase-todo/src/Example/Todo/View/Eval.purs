module Example.Todo.View.Eval (eval, liftExceptT) where

import Control.Monad.Aff (Aff)
import Control.Monad.Eff.Console (errorShow)
import Control.Monad.Eff.Exception (Error, error)
import Control.Monad.Error.Class (class MonadError, throwError)
import Control.Monad.Except (runExcept)
import Control.Monad.Except.Trans (ExceptT)
import Data.BooleanAlgebra (not)
import Data.Either (either)
import Data.Foreign.Class (read, write)
import Data.Functor ((<$))
import Data.Identity (Identity)
import Data.Map (delete, insert, update)
import Data.Maybe (Maybe(..))
import Data.Show (class Show, show)
import Data.Unit (Unit, unit)
import Data.Void (Void)
import Example.Todo.Model.Type (Model(..), Task(..), TaskId(..))
import Example.Todo.View.Type (Connection(..), Effects, Query(..), State)
import Guid (Guid(..), generateGuid)
import Halogen (ComponentDSL, get, liftEff, modify)
import Halogen.Query (liftAff, request)
import Halogen.Query.EventSource (SubscribeStatus(..), eventSource')
import Halogen.Query.HalogenM (subscribe)
import Prelude (type (~>), bind, pure, ($), (<<<), (>>=))
import Web.Firebase (EventType(Value), database, off, on, ref, set, val)

liftExceptT :: forall m e. (MonadError Error m, Show e) => ExceptT e Identity ~> m
liftExceptT = either (throwError <<< error <<< show) pure <<< runExcept

eval :: forall eff. Query ~> ComponentDSL State Query Void (Aff (Effects eff))

eval (Connect next) = next <$ do
    state <- get
    reference <- liftEff $ database state.firebase >>=ref "/"
    modify _ { connection = Connecting reference }
    subscribe $ eventSource' (\resolve -> do
        on Value errorShow resolve reference
        pure $ off reference
    ) (Just <<< request <<< HandleValue)

eval (HandleValue snap reply) = do
    state <- get
    case state.connection of
        Connecting reference -> do
            model <- liftAff $ liftExceptT $ read $ val snap
            modify _ {
                connection = Connected {
                    reference: reference,
                    model: model
                }
            }
            pure (reply Listening)

        Connected connected -> do
            model <- liftAff $ liftExceptT $ read $ val snap
            modify _ {
                connection = Connected connected {
                    model = model
                }
            }
            pure (reply Listening)
        _ -> pure (reply Done)

eval (Disconnect next) = next <$ do
    state <- get
    case state.connection of
        Connected con -> do
            liftEff $ off con.reference
            modify _ { connection = NoConnection }
        c -> pure unit

eval (ToggleCompleted taskId next) = next <$ do
    modify \state -> state {
        connection = case state.connection of
            Connected con@{ model: Model model@{ tasks } } -> Connected $ con {
                model = Model model {
                    tasks = update (\(Task task) -> Just $ Task task {
                        completed = not task.completed
                    }) taskId tasks
                }
            }
            con -> con
    }
    updateFirebase

eval (UpdateDescription taskId value next) = next <$ do
    modify \state -> state {
        connection = case state.connection of
            Connected con@{ model: Model model@{ tasks: tasks } } -> Connected $ con {
                model = Model model {
                    tasks = update (\(Task task) -> Just $ Task task {
                        description = value
                    }) taskId tasks
                }
            }
            con -> con
    }
    updateFirebase

eval (Newtask next) = next <$ do
    Guid guid <- liftEff $ generateGuid
    modify \state -> state {
        connection = case state.connection of
            Connected con@{ model: Model model@{ tasks } } -> Connected $ con {
                model = Model model {
                    tasks = insert (TaskId guid) (Task {
                        completed: false,
                        description: ""
                    }) tasks
                }
            }
            con -> con
    }
    updateFirebase

eval (RemoveTask taskId next) = next <$ do
    modify \state -> state {
        connection = case state.connection of
            Connected con@{ model: Model model@{ tasks } } -> Connected $ con {
                model = Model model {
                    tasks = delete taskId tasks
                }
            }
            con -> con
    }
    updateFirebase

updateFirebase :: forall eff. ComponentDSL State Query Void (Aff (Effects eff)) Unit
updateFirebase = do
    { connection } <- get
    case connection of
        Connected con -> liftEff $ set (write con.model) con.reference
        _ -> pure unit
