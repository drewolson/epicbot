module Epicbot.Web.Router
  ( new
  ) where

import Epicbot.MonadApp (class MonadApp)
import Epicbot.Web.Service.Command as CommandService
import Epicbot.Web.Service.Interactive as InteractiveService
import HTTPure as HTTPure

new :: forall m. MonadApp m => HTTPure.Request -> m HTTPure.Response
new req = case req of
  { path: [] } -> CommandService.handle req
  { path: [ "interactive" ] } -> InteractiveService.handle req
  _ -> HTTPure.notFound
