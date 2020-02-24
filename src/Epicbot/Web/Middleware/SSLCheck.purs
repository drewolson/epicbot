module Epicbot.Web.Middleware.SSLCheck
  ( call
  ) where

import Prelude

import Data.HashMap as HashMap
import Epicbot.MonadApp (class MonadApp)
import Epicbot.Web.Body as Body
import HTTPure as HTTPure

call :: forall m. MonadApp m => (HTTPure.Request -> m HTTPure.Response) -> HTTPure.Request -> m HTTPure.Response
call router req@{ body } =
  if HashMap.member "ssl_check" $ Body.asHashMap body
  then HTTPure.ok "Successful SSL check"
  else router req
