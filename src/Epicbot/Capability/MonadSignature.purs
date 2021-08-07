module Epicbot.Capability.MonadSignature
  ( class MonadSignature
  , isSignatureValid
  ) where

import Prelude
import Epicbot.Slack.Signature (Signature)

class Monad m <= MonadSignature m where
  isSignatureValid :: Int -> Signature -> String -> m Boolean
