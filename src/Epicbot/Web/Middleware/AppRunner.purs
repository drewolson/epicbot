module Epicbot.Web.Middleware.AppRunner
  ( call
  ) where

import Prelude
import Data.UUID as UUID
import Effect.Class (liftEffect)
import Epicbot.App (App)
import Epicbot.App as App
import Epicbot.Env (Env)
import HTTPure as HTTPure
import Record as Record

call :: Env -> (HTTPure.Request -> App HTTPure.Response) -> HTTPure.Request -> HTTPure.ResponseM
call env next request = do
  requestId <- liftEffect $ UUID.genUUID
  let
    requestEnv = Record.merge env { requestId }
  App.runApp requestEnv $ next request
