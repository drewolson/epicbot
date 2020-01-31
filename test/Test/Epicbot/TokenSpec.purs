module Test.Epicbot.TokenSpec where

import Prelude

import Epicbot.Token as Token
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

spec :: Spec Unit
spec = do
  describe "Data.Token" do
    describe "secureEqual" do
      it "correctly compares two tokens" do
        first <- Token.secureEqual "a" "a"
        second <- Token.secureEqual "a" "b"

        first `shouldEqual` true
        second `shouldEqual` false
