module Epicbot.Slack.Signature
  ( Signature
  , fromString
  , isValid
  , toString
  ) where

import Prelude
import Data.Int as Int
import Data.Ord (abs)
import Effect.Class (class MonadEffect, liftEffect)
import Epicbot.Capability.MonadTime (class MonadTime, currentTime)
import Epicbot.Slack.SigningSecret (SigningSecret)
import Epicbot.Slack.SigningSecret as SigningSecret
import Node.Crypto as Crypto
import Node.Crypto.Hash (Algorithm(..))
import Node.Crypto.Hmac as Hmac

newtype Signature
  = Signature String

fromString :: String -> Signature
fromString str = Signature str

toString :: Signature -> String
toString (Signature str) = str

isValid :: forall m. MonadEffect m => MonadTime m => SigningSecret -> Signature -> Int -> String -> m Boolean
isValid signingSecret sig timestamp body = do
  now <- currentTime
  if abs ((now / 1000.0) - (Int.toNumber timestamp)) > 300.0 then
    pure false
  else do
    let
      plaintext = "v0:" <> show timestamp <> ":" <> body
    let
      secret = SigningSecret.toString signingSecret
    hmac <- liftEffect $ Hmac.hex SHA256 secret plaintext
    let
      expected = "v0=" <> hmac
    liftEffect $ Crypto.timingSafeEqualString expected $ toString sig
