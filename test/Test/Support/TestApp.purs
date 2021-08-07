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
import Epicbot.Capability.MonadSignature (class MonadSignature)
import Epicbot.Capability.MonadTime (class MonadTime)
import Epicbot.Index (Index)
import Epicbot.Index as Index
import Epicbot.OnlineStatus (OnlineStatus(..))
import Epicbot.Scraper as Scraper
import Epicbot.Slack.Signature (Signature)

newtype App a = App (ReaderT Index Aff a)

derive newtype instance Functor App

derive newtype instance Apply App

derive newtype instance Applicative App

derive newtype instance Bind App

derive newtype instance Monad App

derive newtype instance MonadEffect App

derive newtype instance MonadAff App

derive newtype instance MonadAsk Index App

instance Has Index App where
  grab :: App Index
  grab = ask

instance MonadLogger App where
  log :: Message -> App Unit
  log = const $ pure unit

instance MonadTime App where
  currentTime :: App Number
  currentTime = pure 1531420618000.0

instance MonadSignature App where
  isSignatureValid :: Int -> Signature -> String -> App Boolean
  isSignatureValid _ _ _ = pure true

instance MonadApp App

runApp :: App ~> Aff
runApp (App responseM) = do
  cards <- Scraper.scrape Offline
  index <- Index.fromCards cards
  runReaderT responseM index
