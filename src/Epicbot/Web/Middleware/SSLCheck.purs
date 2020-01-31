module Epicbot.Web.Middleware.SSLCheck
  ( call
  ) where

import Prelude

import Data.HashMap as HashMap
import Epicbot.App (ResponseM)
import Epicbot.Web.Body as Body
import HTTPure as HTTPure

call :: (HTTPure.Request -> ResponseM) -> HTTPure.Request -> ResponseM
call router req@{ body } =
  if HashMap.member "ssl_check" $ Body.asHashMap body
  then HTTPure.ok "Successful SSL check"
  else router req
