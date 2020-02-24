module Test.Epicbot.TestApp
  ( App(..)
  ) where

import Prelude

import Control.Monad.Logger.Class (class MonadLogger)
import Control.Monad.Reader (class MonadAsk, ReaderT, ask)
import Data.Log.Message (Message)
import Effect.Aff (Aff)
import Effect.Aff.Class (class MonadAff)
import Effect.Class (class MonadEffect)
import Epicbot.Has (class Has)
import Epicbot.Index (Index)
import Epicbot.MonadApp (class MonadApp)
import Epicbot.Slack.SigningSecret (SigningSecret(..))

newtype App a = App (ReaderT Index Aff a)

derive newtype instance functorApp :: Functor App

derive newtype instance applyApp :: Apply App

derive newtype instance applicativeApp :: Applicative App

derive newtype instance bindApp :: Bind App

derive newtype instance monadApp :: Monad App

derive newtype instance monadEffectApp :: MonadEffect App

derive newtype instance monadAffApp :: MonadAff App

derive newtype instance monadAskApp :: MonadAsk Index App

instance hasIndexApp :: Has Index App where
  grab :: App Index
  grab = ask

instance hasSigningSecretApp :: Has SigningSecret App where
  grab :: App SigningSecret
  grab = pure $ SigningSecret "test"

instance monadLoggerApp :: MonadLogger App where
  log :: Message -> App Unit
  log = const $ pure unit

instance monadAppApp :: MonadApp App
