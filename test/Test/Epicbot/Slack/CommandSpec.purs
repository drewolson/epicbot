module Test.Epicbot.Slack.CommandSpec where

import Prelude
import Epicbot.Slack.Command as Command
import Epicbot.Slack.Command (Command(..))
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

spec :: Spec Unit
spec = do
  describe "Epicbot.Slack.Command" do
    describe "parse" do
      it "parses the draft command" do
        Command.parse "draft" `shouldEqual` Draft
      it "parses the draft command with whitespace" do
        Command.parse "draft   " `shouldEqual` Draft
      it "parses the draft command with a newline" do
        Command.parse "draft   \n" `shouldEqual` Draft
      it "parses the search command" do
        Command.parse "this is a search" `shouldEqual` Search "this is a search"
