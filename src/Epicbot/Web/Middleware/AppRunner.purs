module Epicbot.Web.Middleware.AppRunner
  ( call
  ) where

import Prelude

import Control.Monad.Reader (runReaderT)
import Data.UUID as UUID
import Effect.Class (liftEffect)
import Epicbot.App (App(..))
import Epicbot.Env (Env)
import HTTPure as HTTPure
import Record as Record

call :: Env -> (HTTPure.Request -> App HTTPure.Response) -> HTTPure.Request -> HTTPure.ResponseM
call env next request = do
  requestId <- liftEffect $ UUID.genUUID
  let requestEnv = Record.merge env { requestId }
  let (App responseM) = next request

  runReaderT responseM requestEnv
