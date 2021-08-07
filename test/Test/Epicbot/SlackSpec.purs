module Test.Epicbot.SlackSpec where

import Prelude
import Data.Maybe (Maybe(..))
import Epicbot.Slack (Action(..), Attachment(..), CommandResponse(..))
import Epicbot.Slack as Slack
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

spec :: Spec Unit
spec = do
  describe "Epicbot.Slack" do
    describe "searchResponse" do
      it "creates a response with no results" do
        let result = Slack.searchResponse []
        result `shouldEqual`
          CommandResponse
            { responseType: "ephemeral"
            , text: "No card found"
            , attachments: Nothing
            , deleteOriginal: Nothing
            }

      it "creates a response with one result" do
        let
          result = Slack.searchResponse
            [ { id: "1", name: "Drew", urls: [ "image.jpg" ] }
            ]
        result `shouldEqual`
          CommandResponse
            { responseType: "in_channel"
            , text: "Drew"
            , deleteOriginal: Just true
            , attachments:
                Just
                  [ Attachment
                      { actions: Nothing
                      , callbackId: Nothing
                      , text: Nothing
                      , imageUrl: "image.jpg"
                      }
                  ]
            }

      it "creates a response with many results" do
        let
          result = Slack.searchResponse
            [ { id: "1", name: "Drew", urls: [ "image1.jpg" ] }
            , { id: "2", name: "Mary", urls: [ "image2.jpg" ] }
            ]

        result `shouldEqual`
          CommandResponse
            { responseType: "ephemeral"
            , text: "Please select a card"
            , deleteOriginal: Nothing
            , attachments:
                Just
                  [ Attachment
                      { actions:
                          Just
                            [ Action { name: Just "select", text: Just "Select", type: Just "button", value: Just "1" }
                            ]
                      , callbackId: Just "select_card"
                      , text: Just "Drew"
                      , imageUrl: "image1.jpg"
                      }
                  , Attachment
                      { actions:
                          Just
                            [ Action { name: Just "select", text: Just "Select", type: Just "button", value: Just "2" }
                            ]
                      , callbackId: Just "select_card"
                      , text: Just "Mary"
                      , imageUrl: "image2.jpg"
                      }
                  ]
            }
