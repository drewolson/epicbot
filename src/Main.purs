module Main
  ( main
  ) where

import Prelude

import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Class.Console as Console
import Epicbot.Env (Env)
import Epicbot.Wiring as Wiring
import Epicbot.Web.Middleware as Middleware
import Epicbot.Web.Router as Router
import HTTPure as HTTPure

makeServer :: Env -> (HTTPure.Request -> HTTPure.ResponseM) -> HTTPure.ServerM
makeServer { port } handler =
  HTTPure.serve port handler $ Console.log $ "Server running on " <> show port

makeHandler :: Env -> HTTPure.Request -> HTTPure.ResponseM
makeHandler env = Middleware.call env Router.new

main :: Effect Unit
main = launchAff_ do
  env <- Wiring.makeEnv

  liftEffect <<< makeServer env <<< makeHandler $ env
