module Epicbot.App
  ( App(..)
  ) where

import Prelude
import Control.Monad.Logger.Class (class MonadLogger)
import Control.Monad.Reader (class MonadAsk, ReaderT, ask, asks)
import Data.Log.Filter (minimumLevel)
import Data.Log.Formatter.JSON (jsonFormatter)
import Data.Log.Level (LogLevel)
import Data.Log.Message (Message)
import Data.Log.Tag (tag)
import Data.UUID (UUID)
import Data.UUID as UUID
import Effect.Aff (Aff)
import Effect.Aff.Class (class MonadAff)
import Effect.Class (class MonadEffect)
import Effect.Class.Console as Console
import Epicbot.Env (RequestEnv)
import Epicbot.Has (class Has)
import Epicbot.Index (Index)
import Epicbot.MonadApp (class MonadApp)
import Epicbot.Slack.SigningSecret (SigningSecret)
import Type.Equality (class TypeEquals, from)

newtype App a
  = App (ReaderT RequestEnv Aff a)

derive newtype instance functorApp :: Functor App

derive newtype instance applyApp :: Apply App

derive newtype instance applicativeApp :: Applicative App

derive newtype instance bindApp :: Bind App

derive newtype instance monadApp :: Monad App

derive newtype instance monadEffectApp :: MonadEffect App

derive newtype instance monadAffApp :: MonadAff App

instance monadAskApp :: TypeEquals e RequestEnv => MonadAsk e App where
  ask = App $ asks from

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
    addRequestId id m@{ tags } = m { tags = tags <> tag "requestId" (UUID.toString id) }

instance monadAppApp :: MonadApp App
