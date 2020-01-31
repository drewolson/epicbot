module Test.Spec.Util
  ( assertEach
  , mockHttpRequest
  , runApp
  ) where

import Prelude

import Control.Monad.Error.Class (class MonadThrow)
import Control.Monad.Reader (runReaderT)
import Data.Foldable (class Foldable, foldM)
import Data.Log.Level as Level
import Data.UUID as UUID
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Exception (Error)
import Epicbot.App (App(..))
import Epicbot.Env (Env, RequestEnv)
import Epicbot.Wiring as Wiring
import Foreign.Object as Object
import HTTPure.Headers as Headers
import HTTPure.Method (Method(..)) as HTTPure
import HTTPure.Request (Request) as HTTPure
import HTTPure.Version (Version(HTTP2_0))
import Record as Record

runApp :: forall a. App a -> Aff a
runApp (App responseM) = do
  env <- Wiring.makeEnv
  let env' = env { logLevel = Level.Error }
  requestEnv <- makeRequestEnv env'

  runReaderT responseM requestEnv

makeRequestEnv :: Env -> Aff RequestEnv
makeRequestEnv env = do
  requestId <- liftEffect $ UUID.genUUID

  pure $ Record.merge env { requestId }

assertEach :: forall a t m. Foldable t => MonadThrow Error m => t a -> (a -> m Unit) -> m Unit
assertEach xs f = foldM (\_ x -> f x) unit xs

mockHttpRequest :: Array String -> String -> HTTPure.Request
mockHttpRequest path body =
  { method: HTTPure.Get
  , httpVersion: HTTP2_0
  , path
  , query: Object.empty
  , headers: Headers.empty
  , body
  }
