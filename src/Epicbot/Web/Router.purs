module Epicbot.Web.Router
  ( route
  ) where

import Epicbot.MonadApp (class MonadApp)
import Epicbot.Web.Service.Command as CommandService
import Epicbot.Web.Service.Interactive as InteractiveService
import HTTPure as HTTPure

route :: forall m. MonadApp m => HTTPure.Request -> m HTTPure.Response
route req = case req of
  { path: [] } -> CommandService.handle req
  { path: [ "interactive" ] } -> InteractiveService.handle req
  _ -> HTTPure.notFound
