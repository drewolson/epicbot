module Test.Epicbot.ScraperSpec where

import Prelude
import Data.Array as A
import Data.Maybe (Maybe(..))
import Epicbot.Scraper as Scraper
import Epicbot.OnlineStatus (OnlineStatus(..))
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

spec :: Spec Unit
spec = do
  describe "Epicbot.Scraper" do
    describe "scrape" do
      it "returns the parsed results" do
        cards <- Scraper.scrape Offline
        let
          name = _.name <$> A.head cards
        name `shouldEqual` Just "Angeline, Silver Wing"
