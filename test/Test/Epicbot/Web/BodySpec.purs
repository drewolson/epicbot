module Test.Epicbot.Web.BodySpec where

import Prelude

import Data.Map as Map
import Data.Maybe (Maybe(..))
import Epicbot.Web.Body as Body
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

spec :: Spec Unit
spec = do
  describe "Web.Body" do
    describe "asMap" do
      it "parses the body as a map" do
        let map = Body.asMap "a=1&b=2"

        Map.lookup "a" map `shouldEqual` Just "1"
        Map.lookup "b" map `shouldEqual` Just "2"
        Map.lookup "c" map `shouldEqual` Nothing

      it "handles malformed bodies" do
        let map = Body.asMap "this is malformed"

        map `shouldEqual` Map.empty

      it "handles malformed keys" do
        let map = Body.asMap "a=1&bisbad"

        Map.lookup "a" map `shouldEqual` Just "1"
        Map.lookup "b" map `shouldEqual` Nothing
