module Test.Epicbot.Random.ArraySpec where

import Prelude
import Data.Array (length, sort)
import Epicbot.Random.Array as Array
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual, shouldContain)
import Test.Support.Util (assertEach)

spec :: Spec Unit
spec = do
  describe "Effect.Random.Array" do
    describe "shuffle" do
      it "shuffles an array" do
        let
          xs = [ 1, 2, 3, 4 ]
        shuffled <- Array.shuffle xs
        assertEach xs (shuffled `shouldContain` _)
        xs `shouldEqual` sort shuffled
    describe "takeRandom" do
      it "takes random elements from the array" do
        let
          xs = [ 1, 2, 3, 4 ]
        ys <- Array.takeRandom 2 xs
        assertEach ys (xs `shouldContain` _)
        length ys `shouldEqual` 2
