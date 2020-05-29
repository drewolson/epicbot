module Test.Support.TestApp
  ( App
  , runApp
  ) where

import Prelude
import Control.Monad.Logger.Class (class MonadLogger)
import Control.Monad.Reader (class MonadAsk, ReaderT, ask, runReaderT)
import Data.Log.Message (Message)
import Effect.Aff (Aff)
import Effect.Aff.Class (class MonadAff)
import Effect.Class (class MonadEffect)
import Epicbot.Capability.Has (class Has)
import Epicbot.Capability.MonadApp (class MonadApp)
import Epicbot.Capability.MonadTime (class MonadTime)
import Epicbot.Index (Index)
import Epicbot.Index as Index
import Epicbot.OnlineStatus (OnlineStatus(..))
import Epicbot.Scraper as Scraper
import Epicbot.Slack.SigningSecret (SigningSecret)
import Epicbot.Slack.SigningSecret as SigningSecret

newtype App a
  = App (ReaderT Index Aff a)

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
  grab = pure $ SigningSecret.fromString "test"

instance monadLoggerApp :: MonadLogger App where
  log :: Message -> App Unit
  log = const $ pure unit

instance monadTimeApp :: MonadTime App where
  currentTime :: App Number
  currentTime = pure 1531420618000.0

instance monadAppApp :: MonadApp App

runApp :: App ~> Aff
runApp (App responseM) = do
  cards <- Scraper.scrape Offline
  index <- Index.fromCards cards
  runReaderT responseM index
