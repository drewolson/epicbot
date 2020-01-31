module Epicbot.Token
  ( Token
  , fromEnv
  , secureEqual
  ) where

import Prelude

import Data.Maybe (fromMaybe)
import Effect.Class (class MonadEffect, liftEffect)
import Foreign.Object (Object)
import Foreign.Object as Object
import Node.Crypto as Crypto

type Token = String

fromEnv :: Object String -> Token
fromEnv = fromMaybe "test" <<< Object.lookup "SLACK_TOKEN"

secureEqual :: forall m. MonadEffect m => Token -> Token -> m Boolean
secureEqual a b = liftEffect $ Crypto.timingSafeEqualString a b
