module Epicbot.Random.Array
  ( shuffle
  , takeRandom
  ) where

import Prelude
import Control.Monad.ST.Class (liftST)
import Control.Monad.ST.Global (Global)
import Data.Array ((..))
import Data.Array as Array
import Data.Array.ST (STArray)
import Data.Array.ST as STArray
import Data.Foldable (for_)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Random as Random

takeRandom :: forall a m. MonadEffect m => Int -> Array a -> m (Array a)
takeRandom n xs = Array.take n <$> shuffle xs

shuffle :: forall a m. MonadEffect m => Array a -> m (Array a)
shuffle xs =
  liftEffect do
    xs' <- liftST $ STArray.thaw xs
    for_ (0 .. upperBound) \i -> do
      j <- Random.randomInt i upperBound
      vi <- peek i xs'
      vj <- peek j xs'
      poke i vj xs'
      poke j vi xs'
    liftST $ STArray.freeze xs'
  where
  upperBound :: Int
  upperBound = Array.length xs - 1

  peek :: Int -> STArray Global a -> Effect (Maybe a)
  peek ix arr = liftST $ STArray.peek ix arr

  poke :: Int -> Maybe a -> STArray Global a -> Effect Unit
  poke ix maybeVal arr = case maybeVal of
    Just val -> void $ liftST $ STArray.poke ix val arr
    Nothing -> pure unit
