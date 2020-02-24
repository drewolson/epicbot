module Epicbot.Wiring
  ( makeEnv
  ) where

import Prelude

import Data.Log.Level as Level
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Epicbot.Env (Env)
import Epicbot.Index as Index
import Epicbot.OnlineStatus (OnlineStatus(..))
import Epicbot.Port as Port
import Epicbot.Scraper as Scraper
import Epicbot.Slack.SigningSecret as SigningSecret
import Node.Process as Process

makeEnv :: Aff Env
makeEnv = do
  env <- liftEffect $ Process.getEnv
  let signingSecret = SigningSecret.fromEnv env
  let port = Port.fromEnv env
  let logLevel = Level.Info
  cards <- Scraper.scrape Online
  index <- Index.fromCards cards

  pure { index, port, signingSecret, logLevel }
