module Example.Todo.Model.Type where

import Control.Applicative (pure)
import Control.Bind (bind)
import Data.Eq (class Eq)
import Data.Foreign (Foreign, toForeign)
import Data.Foreign.Class (class AsForeign, class IsForeign, read, write)
import Data.Foreign.Generic (defaultOptions, readGeneric, toForeignGeneric)
import Data.Functor (map)
import Data.Generic.Rep (class Generic)
import Data.Map (Map, fromFoldable)
import Data.Map (toList) as Map
import Data.Newtype (class Newtype)
import Data.Ord (class Ord)
import Data.StrMap (StrMap, toList)
import Data.StrMap (fromFoldable) as StrMap
import Data.Traversable (for)
import Data.Tuple (Tuple(..))
import Prelude (($))

newtype TaskId = TaskId String

newtype Task = Task {
    description :: String,
    completed :: Boolean
}

newtype Model = Model {
    tasks :: Map TaskId Task
}

---- instnances
derive instance eqTaskId :: Eq TaskId

derive instance ordTaskId :: Ord TaskId

derive instance newtypeTask :: Newtype Task _

derive instance genericTask :: Generic Task _

instance isForeignTask :: IsForeign Task where
    read = readGeneric defaultOptions { unwrapSingleConstructors = true }

instance asForeignTask :: AsForeign Task where
    write = toForeignGeneric defaultOptions { unwrapSingleConstructors = true }

derive instance newtypeModel :: Newtype Model _

derive instance genericModel :: Generic Model _

instance isForeignModel :: IsForeign Model where
    read value = do
        let xs = readForeignStrMap value
        ys <- for (toList xs.tasks) \(Tuple k v) -> do
            v' <- read v
            pure $ Tuple (TaskId k) v'
        pure $ Model { tasks: fromFoldable ys }

instance asForeignModel :: AsForeign Model where
    write (Model value) = toForeign {
        tasks: StrMap.fromFoldable $ map (\(Tuple (TaskId k) v) -> Tuple k (write v)) (Map.toList value.tasks)
    }

foreign import readForeignStrMap :: Foreign -> { tasks :: StrMap Foreign }
