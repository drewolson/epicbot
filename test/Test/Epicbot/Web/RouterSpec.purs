module Test.Epicbot.Web.RouterSpec where

import Prelude
import Data.Either (Either(..))
import Epicbot.Web.Router (Route(..))
import Epicbot.Web.Router as Router
import Routing.Duplex as Routing
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)
import Test.Support.TestApp as TestApp
import Test.Support.Util as Util

spec :: Spec Unit
spec = do
  describe "Epicbot.Web.Router" do
    describe "route" do
      it "handles a search command" do
        response <- TestApp.runApp $ Router.route $ Util.mockHttpRequest [] "text=plucker"
        body <- Util.readBody response
        response.status `shouldEqual` 200
        body `shouldEqual` "{\"response_type\":\"in_channel\",\"text\":\"Thought Plucker\",\"attachments\":[{\"text\":\"\",\"image_url\":\"http://www.epiccardgame.com/wp-content/uploads/2015/09/thought_plucker-215x300.jpg\"}],\"delete_original\":true}"
    describe "router" do
      it "matches the root path as Command" do
        Routing.parse Router.router "/" `shouldEqual` Right Command
      it "matches the interactive path as Interactive" do
        Routing.parse Router.router "/interactive" `shouldEqual` Right Interactive
