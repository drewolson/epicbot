module Epicbot.MonadApp
  ( class MonadApp
  ) where

import Prelude

import Control.Monad.Logger.Class (class MonadLogger)
import Effect.Aff.Class (class MonadAff)
import Epicbot.Has (class Has)
import Epicbot.Index (Index)
import Epicbot.Slack.SigningSecret (SigningSecret)

class (Monad m, Has Index m, Has SigningSecret m, MonadAff m, MonadLogger m) <= MonadApp m
