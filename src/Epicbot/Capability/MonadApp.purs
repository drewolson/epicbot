module Epicbot.Capability.MonadApp
  ( class MonadApp
  ) where

import Control.Monad.Logger.Class (class MonadLogger)
import Effect.Aff.Class (class MonadAff)
import Epicbot.Capability.Has (class Has)
import Epicbot.Index (Index)
import Epicbot.Slack.SigningSecret (SigningSecret)

class
  ( Has Index m
  , Has SigningSecret m
  , MonadAff m
  , MonadLogger m
  ) <= MonadApp m
