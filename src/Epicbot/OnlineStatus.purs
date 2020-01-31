module Epicbot.OnlineStatus
  ( OnlineStatus(..)
  , fromEnv
  ) where

import Prelude

import Data.Maybe (Maybe(..))
import Foreign.Object (Object)
import Foreign.Object as Object

data OnlineStatus
  = Online
  | Offline

derive instance eqOnlineStatus :: Eq OnlineStatus

instance showOnlineStatus :: Show OnlineStatus where
  show :: OnlineStatus -> String
  show Online  = "Online"
  show Offline = "Offline"

fromEnv :: Object String -> OnlineStatus
fromEnv env = if online then Online else Offline
  where
    online :: Boolean
    online = (_ == Just "1") $ Object.lookup "ONLINE" env
