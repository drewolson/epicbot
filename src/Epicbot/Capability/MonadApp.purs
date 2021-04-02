module Epicbot.Capability.MonadApp
  ( class MonadApp
  ) where

import Control.Monad.Logger.Class (class MonadLogger)
import Effect.Aff.Class (class MonadAff)
import Epicbot.Capability.Has (class Has)
import Epicbot.Capability.MonadSignature (class MonadSignature)
import Epicbot.Capability.MonadTime (class MonadTime)
import Epicbot.Index (Index)

class
  ( Has Index m
  , MonadTime m
  , MonadSignature m
  , MonadAff m
  , MonadLogger m
  ) <= MonadApp m
