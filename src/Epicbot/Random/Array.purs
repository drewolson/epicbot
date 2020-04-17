module Epicbot.Random.Array
  ( shuffle
  , takeRandom
  ) where

import Prelude
import Control.Monad.Rec.Class (class MonadRec)
import Data.Array ((..))
import Data.Array as Array
import Data.Map (Map)
import Data.Map as Map
import Data.Maybe (Maybe, fromMaybe)
import Data.Tuple (Tuple(..))
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Random as Random

takeRandom :: forall a m. MonadEffect m => MonadRec m => Int -> Array a -> m (Array a)
takeRandom n xs = Array.take n <$> shuffle xs

shuffle :: forall a m. MonadEffect m => MonadRec m => Array a -> m (Array a)
shuffle xs = mapToArray <$> Array.foldRecM swap (arrayToMap xs) (0 .. upperBound)
  where
  upperBound :: Int
  upperBound = Array.length xs - 1

  mapToArray :: Map Int a -> Array a
  mapToArray m =
    Array.mapMaybe (flip Map.lookup m)
      <<< Array.sort
      <<< Array.fromFoldable
      <<< Map.keys
      $ m

  arrayToMap :: Array a -> Map Int a
  arrayToMap = Map.fromFoldable <<< Array.mapWithIndex Tuple

  swap :: Map Int a -> Int -> m (Map Int a)
  swap map i = do
    j <- liftEffect $ Random.randomInt i upperBound
    pure <<< fromMaybe map <<< swapKeys i j $ map

  swapKeys :: Int -> Int -> Map Int a -> Maybe (Map Int a)
  swapKeys i j map = do
    iVal <- Map.lookup i map
    jVal <- Map.lookup j map
    pure <<< Map.insert i jVal <<< Map.insert j iVal $ map
