module Followbox.Eval (eval) where

import Control.Monad.Aff (Aff)
import Control.Monad.Eff.Random (randomInt)
import CreateObjectURL (createObjectURL)
import Data.Array (drop, findIndex, head, replicate, tail, take, updateAt)
import Data.Functor ((<$))
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Traversable (for)
import Data.Tuple (Tuple(..))
import Data.Void (Void)
import Followbox.Type (State, Query(..), Effects)
import GithubAPI (User(User), fetchUsers)
import Halogen (ComponentDSL, get, liftEff, modify)
import Halogen.Query (lift)
import Network.HTTP.Affjax (get) as Affjax
import Prelude (type (~>), bind, discard, pure, unit, ($), (<#>), (=<<), (==))

numberOfUsers :: Int
numberOfUsers = 3

eval :: forall eff. Query ~> ComponentDSL State Query Void (Aff (Effects eff))

eval (Close login next) = next <$ do
    state <- get
    fromMaybe (pure unit) do
        index <- findIndex (\u -> (u <#> \(Tuple (User user) _) -> user.login) == Just login) state.display
        users <- tail state.users
        User user <- head state.users
        blank <- updateAt index Nothing state.display
        pure do
            modify _ { display = blank, users = users }
            res <- lift $ Affjax.get user.avatar_url
            url <- liftEff $ createObjectURL res.response
            modify _ { display = fromMaybe state.display $ updateAt index (Just (Tuple (User user) url)) state.display }

eval (Refresh next) = next <$ do
    modify _ { display = replicate numberOfUsers Nothing }
    users <- lift $ fetchUsers =<< (liftEff $ randomInt 0 500)
    display <- lift $ for (take numberOfUsers users) \(User user) -> do
        res <- Affjax.get user.avatar_url
        url <- liftEff $ createObjectURL res.response
        pure $ Just $ Tuple (User user) url
    modify _ { display = display, users = drop numberOfUsers users }

