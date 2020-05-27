module Epicbot.OnlineStatus
  ( OnlineStatus(..)
  ) where

import Prelude
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)

data OnlineStatus
  = Online
  | Offline

derive instance genericOnlineStatus :: Generic OnlineStatus _

derive instance eqOnlineStatus :: Eq OnlineStatus

instance showOnlineStatus :: Show OnlineStatus where
  show :: OnlineStatus -> String
  show = genericShow
