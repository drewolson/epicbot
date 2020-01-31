module Epicbot.Port
  ( fromEnv
  ) where

import Prelude

import Data.Int as Int
import Data.Maybe (fromMaybe)
import Foreign.Object (Object)
import Foreign.Object as Object

fromEnv :: Object String -> Int
fromEnv env =
  fromMaybe 8080 $ Int.fromString =<< Object.lookup "PORT" env
