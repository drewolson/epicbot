module Epicbot.Capability.MonadTime
  ( class MonadTime
  , currentTime
  ) where

import Prelude

class Monad m <= MonadTime m where
  currentTime :: m Number
