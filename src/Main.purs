module Main
  ( main
  ) where

import Prelude
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Class.Console as Console
import Epicbot.App (App)
import Epicbot.Env (Env)
import Epicbot.Web.Middleware.AppRunner as AppRunner
import Epicbot.Web.Router as Router
import Epicbot.Wiring as Wiring
import HTTPure as HTTPure

makeServer :: Env -> (HTTPure.Request -> App HTTPure.Response) -> HTTPure.ServerM
makeServer env handler =
  HTTPure.serve env.port (AppRunner.call env handler) do
    Console.log $ "Server running on " <> show env.port

main :: Effect Unit
main =
  launchAff_ do
    env <- Wiring.makeEnv
    liftEffect $ makeServer env Router.route
