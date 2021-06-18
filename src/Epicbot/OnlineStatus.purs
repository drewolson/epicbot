module Epicbot.OnlineStatus
  ( OnlineStatus(..)
  ) where

import Prelude
import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)

data OnlineStatus
  = Online
  | Offline

derive instance Generic OnlineStatus _

derive instance Eq OnlineStatus

instance Show OnlineStatus where
  show :: OnlineStatus -> String
  show = genericShow
