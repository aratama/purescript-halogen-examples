module GithubAPI (User(..), Users(..), fetchUsers) where

import Control.Monad.Aff (Aff)
import Control.Monad.Eff.Exception (Error, error)
import Control.Monad.Error.Class (class MonadError, throwError)
import Control.Monad.Except (ExceptT, runExcept)
import Data.Either (either)
import Data.Foreign.Class (class Decode, decode)
import Data.Foreign.Generic (genericDecode, defaultOptions)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Identity (Identity)
import Data.Show (class Show)
import Network.HTTP.Affjax (AJAX, URL, get)
import Prelude (bind, pure, show, ($), (<<<), (<>), type (~>))

-- 1. Define data types.
newtype User = User {
    login :: String,
    avatar_url :: URL,
    html_url :: URL
}

type Users = Array User

-- 2. Derive some instances for the newtypes.
instance isForeignUser :: Decode User where
    decode = genericDecode defaultOptions { unwrapSingleConstructors = true }

derive instance genericUser :: Generic User _

instance showUser :: Show User where
    show = genericShow

-- 3. Define an asyncronous fetching function.
fetchUsers :: forall eff. Int -> Aff (ajax :: AJAX | eff) Users
fetchUsers since = do
    res <- get $ "https://api.github.com/users?since=" <> show since
    liftEx $ decode res.response

liftEx :: forall m e. MonadError Error m => Show e => ExceptT e Identity ~> m
liftEx = either (throwError <<< error <<< show) pure <<< runExcept

