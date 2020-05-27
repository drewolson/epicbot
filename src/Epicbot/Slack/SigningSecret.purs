module Epicbot.Slack.SigningSecret
  ( SigningSecret
  , fromEnv
  , fromString
  , toString
  ) where

import Prelude
import Data.Maybe (fromMaybe)
import Foreign.Object (Object)
import Foreign.Object as Object

newtype SigningSecret
  = SigningSecret String

fromEnv :: Object String -> SigningSecret
fromEnv = SigningSecret <<< fromMaybe "test" <<< Object.lookup "SLACK_SIGNING_SECRET"

fromString :: String -> SigningSecret
fromString str = SigningSecret str

toString :: SigningSecret -> String
toString (SigningSecret signingSecret) = signingSecret
