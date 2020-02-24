module Epicbot.Web.Middleware.SignatureCheck
  ( call
  ) where

import Prelude

import Control.Monad.Logger.Class (class MonadLogger, info)
import Data.Log.Tag (empty)
import Data.Maybe (Maybe(..))
import Effect.Aff.Class (class MonadAff)
import Epicbot.Has (class Has, grab)
import Epicbot.Slack.Signature as Signature
import Epicbot.Slack.SigningSecret (SigningSecret)
import HTTPure ((!!))
import HTTPure as HTTPure

call
  :: forall m
   . MonadAff m
  => Has SigningSecret m
  => MonadLogger m
  => (HTTPure.Request -> m HTTPure.Response)
  -> HTTPure.Request
  -> m HTTPure.Response
call router req@{ body, headers } = do
  signingSecret <- grab
  let maybeTimestamp = headers !! "X-Slack-Request-Timestamp"
  let maybeSig = headers !! "X-Slack-Signature"

  case maybeTimestamp, maybeSig of
    Just timestamp, Just sig -> do
      valid <- Signature.isValid signingSecret timestamp sig body

      if valid
        then router req
        else do
          info empty "Bad signature"
          HTTPure.unauthorized

    _, _ -> do
      info empty "No signature found"
      HTTPure.unauthorized
