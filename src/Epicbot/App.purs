module Epicbot.App
  ( App
  , runApp
  ) where

import Prelude
import Control.Monad.Logger.Class (class MonadLogger)
import Control.Monad.Reader (class MonadAsk, ReaderT, ask, asks, runReaderT)
import Data.JSDate as JSDate
import Data.Log.Filter (minimumLevel)
import Data.Log.Formatter.JSON (jsonFormatter)
import Data.Log.Level (LogLevel)
import Data.Log.Message (Message)
import Data.Log.Tag (tag)
import Data.Map (union)
import Data.UUID (UUID)
import Data.UUID as UUID
import Effect.Aff (Aff)
import Effect.Aff.Class (class MonadAff)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Class.Console as Console
import Epicbot.Capability.Has (class Has)
import Epicbot.Capability.MonadApp (class MonadApp)
import Epicbot.Capability.MonadSignature (class MonadSignature)
import Epicbot.Capability.MonadTime (class MonadTime)
import Epicbot.Env (RequestEnv)
import Epicbot.Index (Index)
import Epicbot.Slack.Signature (Signature)
import Epicbot.Slack.Signature as Signature

newtype App a = App (ReaderT RequestEnv Aff a)

derive newtype instance Functor App

derive newtype instance Apply App

derive newtype instance Applicative App

derive newtype instance Bind App

derive newtype instance Monad App

derive newtype instance MonadEffect App

derive newtype instance MonadAff App

derive newtype instance MonadAsk RequestEnv App

instance Has Index App where
  grab :: App Index
  grab = asks _.index

instance MonadLogger App where
  log :: Message -> App Unit
  log message = do
    { logLevel, requestId } <- ask
    logMessage requestId logLevel message
    where
    logMessage :: UUID -> LogLevel -> Message -> App Unit
    logMessage requestId logLevel = minimumLevel logLevel $ Console.log <<< jsonFormatter <<< addRequestId requestId

    addRequestId :: UUID -> Message -> Message
    addRequestId id m@{ tags } = m { tags = tags `union` tag "requestId" (UUID.toString id) }

instance MonadTime App where
  currentTime :: App Number
  currentTime = liftEffect $ JSDate.getTime <$> JSDate.now

instance MonadSignature App where
  isSignatureValid :: Int -> Signature -> String -> App Boolean
  isSignatureValid timestamp signature body = do
    signingSecret <- asks _.signingSecret
    Signature.isValid signingSecret signature timestamp body

instance MonadApp App

runApp :: RequestEnv -> App ~> Aff
runApp requestEnv (App app) = do
  runReaderT app requestEnv
