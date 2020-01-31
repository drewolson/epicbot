module Test.Epicbot.IndexSpec where

import Prelude

import Epicbot.Index as Index
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldContain, shouldEqual, shouldNotContain)

spec :: Spec Unit
spec = do
  describe "Epicbot.Index" do
    describe "searchResponse" do
      it "creates a response with no results" do
        let index = Index.new
        let results = Index.search "foo" index

        results `shouldEqual` []

    describe "search" do
      it "returns relevant results" do
        index <- Index.fromCards
          [ { name: "Drew", id: "1", urls: [] }
          , { name: "Mary", id: "2", urls: [] }
          ]

        let matches = map _.id $ Index.search "Drew" $ index

        matches `shouldContain` "1"
        matches `shouldNotContain` "2"
