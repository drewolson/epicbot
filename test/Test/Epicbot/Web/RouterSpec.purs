module Test.Epicbot.Web.RouterSpec where

import Prelude
import Data.Either (Either(..))
import Epicbot.Web.Router (Route(..))
import Epicbot.Web.Router as Router
import Routing.Duplex as Routing
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

spec :: Spec Unit
spec = do
  describe "Epicbot.Web.Router" do
    describe "router" do
      it "matches the root path as Command" do
        Routing.parse Router.router "/" `shouldEqual` Right Command
      it "matches the interactive path as Interactive" do
        Routing.parse Router.router "/interactive" `shouldEqual` Right Interactive
