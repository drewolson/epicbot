module Test.Support.Util
  ( assertEach
  , mockHttpRequest
  ) where

import Prelude
import Control.Monad.Error.Class (class MonadThrow)
import Data.Foldable (class Foldable, foldM)
import Effect.Exception (Error)
import Foreign.Object as Object
import HTTPure.Headers as Headers
import HTTPure.Method (Method(..)) as HTTPure
import HTTPure.Request (Request) as HTTPure
import HTTPure.Version (Version(HTTP2_0))

assertEach :: forall a t m. Foldable t => MonadThrow Error m => t a -> (a -> m Unit) -> m Unit
assertEach xs f = foldM (\_ x -> f x) unit xs

mockHttpRequest :: Array String -> String -> HTTPure.Request
mockHttpRequest path body =
  { method: HTTPure.Get
  , httpVersion: HTTP2_0
  , path
  , body
  , query: Object.empty
  , headers: Headers.empty
  , url: "http://example.com"
  }
