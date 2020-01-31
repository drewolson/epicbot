module Test.Epicbot.WiringSpec where

import Prelude

import Epicbot.Wiring as Wiring
import Epicbot.Index as Index
import Epicbot.OnlineStatus (OnlineStatus(..))
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

spec :: Spec Unit
spec = do
  describe "Effect.Wiring" do
    describe "makeEnv" do
      it "returns the env with a new index" do
        env <- Wiring.makeEnv
        let results = Index.search "foo" env.index

        results `shouldEqual` []

      it "defaults the token to 'test'" do
        env <- Wiring.makeEnv

        env.token `shouldEqual` "test"

      it "sets onlineStatus to offline" do
        env <- Wiring.makeEnv

        env.onlineStatus `shouldEqual` Offline
