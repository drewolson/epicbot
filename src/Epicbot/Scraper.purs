module Epicbot.Scraper
  ( scrape
  ) where

import Prelude
import Effect.Aff (Aff)
import Epicbot.Card (Card)
import Epicbot.Http as Http
import Epicbot.Html.Parser as Parser
import Epicbot.OnlineStatus (OnlineStatus(..))
import Milkis as Milkis
import Node.Encoding (Encoding(UTF8))
import Node.FS.Aff as FS

testDocPath :: String
testDocPath = "./data/card-gallery.html"

prodUrl :: Milkis.URL
prodUrl = Milkis.URL "http://www.epiccardgame.com/card-gallery/"

getPage :: OnlineStatus -> Aff String
getPage Offline = FS.readTextFile UTF8 testDocPath

getPage Online = Milkis.text =<< Http.get prodUrl

scrape :: OnlineStatus -> Aff (Array Card)
scrape onlineStatus = Parser.parseCards <$> getPage onlineStatus
