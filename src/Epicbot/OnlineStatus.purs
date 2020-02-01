module Epicbot.OnlineStatus
  ( OnlineStatus(..)
  , fromEnv
  ) where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Maybe (Maybe(..))
import Foreign.Object (Object)
import Foreign.Object as Object

data OnlineStatus
  = Online
  | Offline

derive instance genericOnlineStatue :: Generic OnlineStatus _

derive instance eqOnlineStatue :: Eq OnlineStatus

instance showOnlineStatus :: Show OnlineStatus where
  show = genericShow

fromEnv :: Object String -> OnlineStatus
fromEnv env = if online then Online else Offline
  where
    online :: Boolean
    online = (_ == Just "1") $ Object.lookup "ONLINE" env
