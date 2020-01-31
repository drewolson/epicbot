module Epicbot.App
  ( App(..)
  , ResponseM
  ) where

import Prelude

import Control.Monad.Logger.Class (class MonadLogger)
import Control.Monad.Reader (class MonadAsk, ReaderT, ask, asks)
import Data.Log.Filter (minimumLevel)
import Data.Log.Formatter.JSON (jsonFormatter)
import Data.Log.Level (LogLevel)
import Data.Log.Message (Message)
import Data.Log.Tag (tag)
import Data.Newtype (class Newtype)
import Data.UUID (UUID)
import Data.UUID as UUID
import Effect.Aff (Aff)
import Effect.Aff.Class (class MonadAff)
import Effect.Class (class MonadEffect)
import Effect.Class.Console as Console
import Epicbot.Env (RequestEnv)
import HTTPure as HTTPure
import Type.Equality (class TypeEquals, from)

newtype App a = App (ReaderT RequestEnv Aff a)

derive instance newtypeApp :: Newtype (App a) _

derive newtype instance functorApp :: Functor App

derive newtype instance applyApp :: Apply App

derive newtype instance applicativeApp :: Applicative App

derive newtype instance bindApp :: Bind App

derive newtype instance monadApp :: Monad App

derive newtype instance monadEffectApp :: MonadEffect App

derive newtype instance monadAffApp :: MonadAff App

instance monadAskApp :: TypeEquals e RequestEnv => MonadAsk e App where
  ask = App $ asks from

instance monadLoggerApp :: MonadLogger App where
  log :: Message -> App Unit
  log message = do
    { logLevel, requestId } <- ask

    logMessage requestId logLevel message
    where
      logMessage :: UUID -> LogLevel -> Message -> App Unit
      logMessage requestId logLevel =
        minimumLevel logLevel $ Console.log <<< jsonFormatter <<< addRequestId requestId

      addRequestId :: UUID -> Message -> Message
      addRequestId id m@{ tags } =
         m { tags = tags <> tag "requestId" (UUID.toString id) }

type ResponseM = App HTTPure.Response
