module Epicbot.Web.Body
  ( asMap
  ) where

import Prelude
import Data.FormURLEncoded as FormURLEncoded
import Data.Map (Map)
import Data.Map as Map
import Data.Maybe as Maybe

asMap :: String -> Map String String
asMap =
  Map.mapMaybe identity
    <<< Map.fromFoldable
    <<< Maybe.maybe [] FormURLEncoded.toArray
    <<< FormURLEncoded.decode
