module Epicbot.Web.Middleware
  ( call
  ) where

import Prelude

import Epicbot.App (App)
import Epicbot.Env (Env)
import Epicbot.Web.Middleware.AppRunner as AppRunner
import Epicbot.Web.Middleware.RequestLogger as RequestLogger
import Epicbot.Web.Middleware.SSLCheck as SSLCheck
import Epicbot.Web.Middleware.SignatureCheck as SignatureCheck
import HTTPure as HTTPure

call :: Env -> (HTTPure.Request -> App HTTPure.Response) -> HTTPure.Request -> HTTPure.ResponseM
call env =
  AppRunner.call env
  <<< RequestLogger.call
  <<< SignatureCheck.call
  <<< SSLCheck.call
