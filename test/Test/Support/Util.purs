module Test.Support.Util
  ( assertEach
  , decodeBody
  , decodeString
  , mockHttpRequest
  , readBody
  ) where

import Prelude
import Control.Monad.Error.Class (class MonadThrow, throwError)
import Data.Argonaut (class DecodeJson, decodeJson, jsonParser)
import Data.Bifunctor (lmap)
import Data.Either (Either(..))
import Data.Foldable (class Foldable, foldM)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Aff (Aff, error)
import Effect.Class (liftEffect)
import Effect.Exception (Error)
import Foreign.Object as Object
import HTTPure as HTTPure
import HTTPure.Headers as Headers
import HTTPure.Version (Version(HTTP2_0))
import Node.HTTP as HTTP

foreign import mockResponse :: Effect HTTP.Response

foreign import readBufferedBody :: HTTP.Response -> Effect String

assertEach :: forall a t m. Foldable t => MonadThrow Error m => t a -> (a -> m Unit) -> m Unit
assertEach xs f = foldM (\_ x -> f x) unit xs

decodeBody :: forall a. DecodeJson a => HTTPure.Response -> Aff a
decodeBody resp = do
  body <- readBody resp

  case decodeString body of
    Left e -> throwError $ error e
    Right val -> pure val

decodeString :: forall a. DecodeJson a => String -> Either String a
decodeString = (lmap show <<< decodeJson) <=< jsonParser

mockHttpRequest :: Array String -> String -> HTTPure.Request
mockHttpRequest path body =
  { method: HTTPure.Get
  , httpVersion: HTTP2_0
  , path
  , body
  , query: Object.empty
  , url: "http://example.com"
  , headers:
      Headers.headers
        [ "X-Slack-Request-Timestamp" /\ "12345"
        , "X-Slack-Signature" /\ "signature"
        ]
  }

readBody :: HTTPure.Response -> Aff String
readBody response = do
  resp <- liftEffect mockResponse
  response.writeBody resp
  liftEffect $ readBufferedBody resp
