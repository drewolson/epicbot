module Test.Epicbot.Web.Service.CommandSpec where

import Prelude
import Data.Maybe (Maybe(..))
import Epicbot.Slack (Attachment(..), CommandResponse(..))
import Epicbot.Web.Service.Command as CommandService
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)
import Test.Support.TestApp as TestApp
import Test.Support.Util as Util

spec :: Spec Unit
spec = do
  describe "Web.Service.Command" do
    describe "handle" do
      it "parses the body as a map" do
        response <- TestApp.runApp $ CommandService.handle $ Util.mockHttpRequest [] "text=plucker"
        response.status `shouldEqual` 200
    describe "executeCommand" do
      it "executes a search" do
        response <- TestApp.runApp $ CommandService.executeCommand "plucker"
        response
          `shouldEqual`
            CommandResponse
              { responseType: "in_channel"
              , text: "Thought Plucker"
              , deleteOriginal: Just true
              , attachments:
                  Just
                    [ Attachment
                        { actions: Nothing
                        , callbackId: Nothing
                        , text: Nothing
                        , imageUrl: "http://www.epiccardgame.com/wp-content/uploads/2015/09/thought_plucker-215x300.jpg"
                        }
                    ]
              }
