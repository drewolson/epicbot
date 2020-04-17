module Test.Support.Util
  ( assertEach
  , mockHttpRequest
  , runApp
  ) where

import Prelude
import Control.Monad.Error.Class (class MonadThrow)
import Control.Monad.Reader (runReaderT)
import Data.Foldable (class Foldable, foldM)
import Effect.Aff (Aff)
import Effect.Exception (Error)
import Epicbot.Index as Index
import Epicbot.OnlineStatus (OnlineStatus(..))
import Epicbot.Scraper as Scraper
import Foreign.Object as Object
import HTTPure.Headers as Headers
import HTTPure.Method (Method(..)) as HTTPure
import HTTPure.Request (Request) as HTTPure
import HTTPure.Version (Version(HTTP2_0))
import Test.Support.TestApp (App(..))

runApp :: forall a. App a -> Aff a
runApp (App responseM) = do
  cards <- Scraper.scrape Offline
  index <- Index.fromCards cards
  runReaderT responseM index

assertEach :: forall a t m. Foldable t => MonadThrow Error m => t a -> (a -> m Unit) -> m Unit
assertEach xs f = foldM (\_ x -> f x) unit xs

mockHttpRequest :: Array String -> String -> HTTPure.Request
mockHttpRequest path body =
  { method: HTTPure.Get
  , httpVersion: HTTP2_0
  , path
  , query: Object.empty
  , headers: Headers.empty
  , body
  }
