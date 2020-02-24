module Epicbot.Web.Middleware.RequestLogger
  ( call
  ) where

import Prelude

import Control.Monad.Logger.Class (class MonadLogger, info)
import Data.Log.Tag (empty)
import HTTPure as HTTPure

call :: forall m. MonadLogger m => (HTTPure.Request -> m HTTPure.Response) -> HTTPure.Request -> m HTTPure.Response
call next req@{ body, method, path, query } = do
  info empty $ "Handling request: " <> show { body, method, path, query }

  response <- next req

  info empty $ "Response status: " <> show response.status

  pure response
