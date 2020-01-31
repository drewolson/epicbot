module Epicbot.Http
  ( fetch
  , get
  ) where

import Prelude

import Effect.Aff (Aff)
import Milkis as Milkis
import Milkis.Impl.Node (nodeFetch)

fetch :: Milkis.Fetch
fetch = Milkis.fetch nodeFetch

get :: Milkis.URL -> Aff Milkis.Response
get = flip fetch Milkis.defaultFetchOptions
