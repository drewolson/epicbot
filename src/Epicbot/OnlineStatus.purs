module Epicbot.OnlineStatus
  ( OnlineStatus(..)
  ) where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)

data OnlineStatus
  = Online
  | Offline

derive instance genericOnlineStatue :: Generic OnlineStatus _

derive instance eqOnlineStatue :: Eq OnlineStatus

instance showOnlineStatus :: Show OnlineStatus where
  show = genericShow
