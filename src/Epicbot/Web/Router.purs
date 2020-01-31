module Epicbot.Web.Router
  ( new
  ) where

import Epicbot.App (ResponseM)
import Epicbot.Web.Service.Command as CommandService
import Epicbot.Web.Service.Interactive as InteractiveService
import HTTPure as HTTPure

new :: HTTPure.Request -> ResponseM
new req = case req of
  { path: [] } ->
    CommandService.handle req

  { path: ["interactive"] } ->
    InteractiveService.handle req

  _  ->
    HTTPure.notFound
