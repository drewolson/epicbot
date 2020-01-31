module Epicbot.Slack.Signature
  ( isValid
  ) where

import Prelude

import Data.JSDate as JSDate
import Data.Maybe (Maybe(..))
import Data.Number as Number
import Data.Ord (abs)
import Effect.Class (class MonadEffect, liftEffect)
import Epicbot.Slack.Token (Token)
import Node.Crypto as Crypto
import Node.Crypto.Hash (Algorithm(..))
import Node.Crypto.Hmac as Hmac

isValid :: forall m. MonadEffect m => Token -> String -> String -> String -> m Boolean
isValid signingSecret timestamp sig body = do
  now <- liftEffect $ JSDate.getTime <$> JSDate.now

  case Number.fromString timestamp of
    Nothing ->
      pure false

    Just time ->
      if abs ((now / 1000.0) - time) > 300.0
        then pure false
        else do
          let plaintext = "v0:" <> timestamp <> ":" <> body
          hmac <- liftEffect $ Hmac.hex SHA256 signingSecret plaintext
          let expected = "v0=" <> hmac

          liftEffect $ Crypto.timingSafeEqualString expected sig
