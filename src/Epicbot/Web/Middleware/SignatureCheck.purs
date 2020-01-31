module Epicbot.Web.Middleware.SignatureCheck
  ( call
  ) where

import Prelude

import Control.Monad.Logger.Class (info)
import Control.Monad.Reader (ask)
import Data.Log.Tag (empty)
import Data.Maybe (Maybe(..))
import Epicbot.App (ResponseM)
import Epicbot.Slack.Signature as Signature
import HTTPure ((!!))
import HTTPure as HTTPure

call :: (HTTPure.Request -> ResponseM) -> HTTPure.Request -> ResponseM
call router req@{ body, headers } = do
  { signingSecret } <- ask
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
