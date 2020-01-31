module Epicbot.Slack.SigningSecret
  ( SigningSecret
  , fromEnv
  ) where

import Prelude

import Data.Maybe (fromMaybe)
import Foreign.Object (Object)
import Foreign.Object as Object

type SigningSecret = String

fromEnv :: Object String -> SigningSecret
fromEnv = fromMaybe "test" <<< Object.lookup "SLACK_SIGNING_SECRET"
