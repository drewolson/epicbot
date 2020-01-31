module Test.Epicbot.Web.BodySpec where

import Prelude

import Data.HashMap as HashMap
import Data.Maybe (Maybe(..))
import Epicbot.Web.Body as Body
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

spec :: Spec Unit
spec = do
  describe "Web.Body" do
    describe "asHashMap" do
      it "parses the body as a map" do
        let map = Body.asHashMap "a=1&b=2"

        HashMap.lookup "a" map `shouldEqual` Just "1"
        HashMap.lookup "b" map `shouldEqual` Just "2"
        HashMap.lookup "c" map `shouldEqual` Nothing

      it "handles malformed bodies" do
        let map = Body.asHashMap "this is malformed"

        map `shouldEqual` HashMap.empty

      it "handles malformed keys" do
        let map = Body.asHashMap "a=1&bisbad"

        HashMap.lookup "a" map `shouldEqual` Just "1"
        HashMap.lookup "b" map `shouldEqual` Nothing
