module Epicbot.Slack.SigningSecret
  ( SigningSecret(..)
  , fromEnv
  ) where

import Prelude
import Data.Maybe (fromMaybe)
import Foreign.Object (Object)
import Foreign.Object as Object

newtype SigningSecret
  = SigningSecret String

derive newtype instance eqSigningSecret :: Eq SigningSecret

derive newtype instance showSigningSecret :: Show SigningSecret

fromEnv :: Object String -> SigningSecret
fromEnv = SigningSecret <<< fromMaybe "test" <<< Object.lookup "SLACK_SIGNING_SECRET"
