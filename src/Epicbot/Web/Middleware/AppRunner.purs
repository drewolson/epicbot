module Epicbot.Web.Middleware.AppRunner
  ( call
  ) where

import Prelude

import Control.Monad.Reader (runReaderT)
import Data.UUID as UUID
import Effect.Class (liftEffect)
import Epicbot.App (App(..), ResponseM)
import Epicbot.Env (Env)
import HTTPure as HTTPure
import Record as Record

call :: Env -> (HTTPure.Request -> ResponseM) -> HTTPure.Request -> HTTPure.ResponseM
call env router request = do
  requestId <- liftEffect $ UUID.genUUID
  let requestEnv = Record.merge env { requestId }
  let (App responseM) = router request

  runReaderT responseM requestEnv
