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
import Data.UUID (UUID)
import Data.UUID as UUID
import Data.Map (union)
import Effect.Aff (Aff)
import Effect.Aff.Class (class MonadAff)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Class.Console as Console
import Epicbot.Capability.Has (class Has)
import Epicbot.Capability.MonadApp (class MonadApp)
import Epicbot.Capability.MonadTime (class MonadTime)
import Epicbot.Env (RequestEnv)
import Epicbot.Index (Index)
import Epicbot.Slack.SigningSecret (SigningSecret)

newtype App a
  = App (ReaderT RequestEnv Aff a)

derive newtype instance functorApp :: Functor App

derive newtype instance applyApp :: Apply App

derive newtype instance applicativeApp :: Applicative App

derive newtype instance bindApp :: Bind App

derive newtype instance monadApp :: Monad App

derive newtype instance monadEffectApp :: MonadEffect App

derive newtype instance monadAffApp :: MonadAff App

derive newtype instance monadAskApp :: MonadAsk RequestEnv App

instance hasIndexApp :: Has Index App where
  grab :: App Index
  grab = asks _.index

instance hasSigningSecretApp :: Has SigningSecret App where
  grab :: App SigningSecret
  grab = asks _.signingSecret

instance monadLoggerApp :: MonadLogger App where
  log :: Message -> App Unit
  log message = do
    { logLevel, requestId } <- ask
    logMessage requestId logLevel message
    where
    logMessage :: UUID -> LogLevel -> Message -> App Unit
    logMessage requestId logLevel = minimumLevel logLevel $ Console.log <<< jsonFormatter <<< addRequestId requestId

    addRequestId :: UUID -> Message -> Message
    addRequestId id m@{ tags } = m { tags = tags `union` tag "requestId" (UUID.toString id) }

instance monadTimeApp :: MonadTime App where
  currentTime :: App Number
  currentTime = liftEffect $ JSDate.getTime <$> JSDate.now

instance monadAppApp :: MonadApp App

runApp :: RequestEnv -> App ~> Aff
runApp requestEnv (App app) = do
  runReaderT app requestEnv
