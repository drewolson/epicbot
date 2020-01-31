module Epicbot.Slack.Token
  ( Token
  , fromEnv
  ) where

import Prelude

import Data.Maybe (fromMaybe)
import Foreign.Object (Object)
import Foreign.Object as Object

type Token = String

fromEnv :: Object String -> Token
fromEnv = fromMaybe "test" <<< Object.lookup "SLACK_TOKEN"
