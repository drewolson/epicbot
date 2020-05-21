module Test.Epicbot.Web.Service.InteractiveSpec where

import Prelude
import Epicbot.Web.Service.Interactive as InteractiveService
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)
import Test.Support.TestApp as TestApp
import Test.Support.Util (mockHttpRequest)

spec :: Spec Unit
spec = do
  describe "Web.Service.Interactive" do
    describe "handle" do
      it "returns a 200" do
        response <- TestApp.runApp $ InteractiveService.handle $ mockHttpRequest [ "interactive" ] "payload=%7B%22type%22%3A%22interactive_message%22%2C%22actions%22%3A%5B%7B%22name%22%3A%22select%22%2C%22type%22%3A%22button%22%2C%22value%22%3A%2230%22%7D%5D%2C%22callback_id%22%3A%22select_card%22%2C%22team%22%3A%7B%22id%22%3A%22T02GDQU9V%22%2C%22domain%22%3A%22readwriteexecute%22%7D%2C%22channel%22%3A%7B%22id%22%3A%22D02GVC16A%22%2C%22name%22%3A%22directmessage%22%7D%2C%22user%22%3A%7B%22id%22%3A%22U02GVC15W%22%2C%22name%22%3A%22drew%22%7D%2C%22action_ts%22%3A%221558650029.016648%22%2C%22message_ts%22%3A%221558649840.000400%22%2C%22attachment_id%22%3A%222%22%2C%22token%22%3A%22stuff%22%2C%22is_app_unfurl%22%3Afalse%2C%22response_url%22%3A%22https%3A%5C%2F%5C%2Fhooks.slack.com%5C%2Factions%5C%2FT02GDQU9V%5C%2F633405213202%5C%2FQ2IyqrX5qFrtUrJqFFZTWEzo%22%2C%22trigger_id%22%3A%22644305832500.2557844335.173dacc17275095ef5a1f35bd2561537%22%7D"
        response.status `shouldEqual` 200
