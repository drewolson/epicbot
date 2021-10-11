module Epicbot.Web.Middleware
  ( call
  ) where

import Prelude

import Effect.Aff.Class (class MonadAff)
import Epicbot.Capability.MonadApp (class MonadApp)
import Epicbot.Web.Middleware.RequestLogger as RequestLogger
import Epicbot.Web.Middleware.SSLCheck as SSLCheck
import Epicbot.Web.Middleware.SignatureCheck as SignatureCheck
import HTTPure as HTTPure

call :: forall m. MonadAff m => MonadApp m => (HTTPure.Request -> m HTTPure.Response) -> HTTPure.Request -> m HTTPure.Response
call =
  RequestLogger.call
    <<< SignatureCheck.call
    <<< SSLCheck.call
