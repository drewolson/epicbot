module Epicbot.Web.Response
  ( jsonResponse
  ) where

import Prelude

import Data.Argonaut.Core (stringify)
import Data.Argonaut.Encode (class EncodeJson, encodeJson)
import Effect.Aff.Class (class MonadAff)
import HTTPure as HTTPure
import HTTPure.Headers (Headers)
import HTTPure.Headers as Headers

jsonResponse :: forall a m. EncodeJson a => MonadAff m => a -> m HTTPure.Response
jsonResponse = HTTPure.ok' jsonHeaders <<< stringify <<< encodeJson

jsonHeaders :: Headers
jsonHeaders = Headers.header "Content-Type" "application/json"
