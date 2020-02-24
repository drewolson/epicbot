module Epicbot.Web.Middleware.RequestLogger
  ( call
  ) where

import Prelude

import Control.Monad.Logger.Class (info)
import Data.Log.Tag (empty)
import Epicbot.MonadApp (class MonadApp)
import HTTPure as HTTPure

call :: forall m. MonadApp m => (HTTPure.Request -> m HTTPure.Response) -> HTTPure.Request -> m HTTPure.Response
call router req@{ body, method, path, query } = do
  info empty $ "Handling request: " <> show { body, method, path, query }

  response <- router req

  info empty $ "Response status: " <> show response.status

  pure response
