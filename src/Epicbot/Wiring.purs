module Epicbot.Wiring
  ( makeEnv
  ) where

import Prelude

import Data.Int as Int
import Data.Log.Level as Level
import Data.Maybe (fromMaybe)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Epicbot.Env (Env)
import Epicbot.Index as Index
import Epicbot.OnlineStatus as OnlineStatus
import Epicbot.Scraper as Scraper
import Epicbot.Slack.SigningSecret as SigningSecret
import Foreign.Object as Object
import Node.Process as Process

makeEnv :: Aff Env
makeEnv = do
  env <- liftEffect $ Process.getEnv
  let signingSecret = SigningSecret.fromEnv env
  let onlineStatus = OnlineStatus.fromEnv env
  let port = fromMaybe 8080 $ Int.fromString =<< Object.lookup "PORT" env
  let logLevel = Level.Info
  cards <- Scraper.scrape onlineStatus
  index <- Index.fromCards cards

  pure { index, onlineStatus, port, signingSecret, logLevel }
