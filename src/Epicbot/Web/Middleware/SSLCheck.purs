module Epicbot.Web.Middleware.SSLCheck
  ( call
  ) where

import Prelude

import Data.Map as Map
import Effect.Aff.Class (class MonadAff)
import Epicbot.Web.Body as Body
import HTTPure as HTTPure

call :: forall m. MonadAff m => (HTTPure.Request -> m HTTPure.Response) -> HTTPure.Request -> m HTTPure.Response
call router req@{ body } =
  if Map.member "ssl_check" $ Body.asMap body
  then HTTPure.ok "Successful SSL check"
  else router req
