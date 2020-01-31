module Epicbot.Web.Middleware
  ( call
  ) where

import Prelude

import Epicbot.App (ResponseM)
import Epicbot.Env (Env)
import Epicbot.Web.Middleware.AppRunner as AppRunner
import Epicbot.Web.Middleware.RequestLogger as RequestLogger
import Epicbot.Web.Middleware.SSLCheck as SSLCheck
import Epicbot.Web.Middleware.TokenCheck as TokenCheck
import HTTPure as HTTPure

call :: Env -> (HTTPure.Request -> ResponseM) -> HTTPure.Request -> HTTPure.ResponseM
call env =
  AppRunner.call env
  <<< RequestLogger.call
  <<< TokenCheck.call
  <<< SSLCheck.call
