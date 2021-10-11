module Epicbot.Web.Middleware.SignatureCheck
  ( call
  ) where

import Prelude

import Control.Monad.Logger.Class (info)
import Data.Int as Int
import Data.Log.Tag (empty)
import Data.Maybe (Maybe(..))
import Effect.Aff.Class (class MonadAff)
import Epicbot.Capability.MonadApp (class MonadApp)
import Epicbot.Capability.MonadSignature as MonadSignature
import Epicbot.Slack.Signature as Signature
import HTTPure ((!!))
import HTTPure as HTTPure

call
  :: forall m
   . MonadApp m
  => MonadAff m
  => (HTTPure.Request -> m HTTPure.Response)
  -> HTTPure.Request
  -> m HTTPure.Response
call next req@{ body, headers } = do
  let maybeTimestamp = Int.fromString =<< headers !! "X-Slack-Request-Timestamp"
  let maybeSig = Signature.fromString <$> headers !! "X-Slack-Signature"

  case maybeTimestamp, maybeSig of
    Just timestamp, Just sig -> do
      valid <- MonadSignature.isSignatureValid timestamp sig body
      if valid then
        next req
      else do
        info empty "Bad signature"
        HTTPure.unauthorized
    _, _ -> do
      info empty "No signature found"
      HTTPure.unauthorized
