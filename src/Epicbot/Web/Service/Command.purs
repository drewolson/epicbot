module Epicbot.Web.Service.Command
  ( executeCommand
  , handle
  ) where

import Prelude
import Data.Map as Map
import Data.Maybe (fromMaybe)
import Effect.Aff.Class (class MonadAff)
import Epicbot.Capability.Has (class Has, grab)
import Epicbot.Index (Index)
import Epicbot.Index as Index
import Epicbot.Slack (CommandResponse)
import Epicbot.Slack as Slack
import Epicbot.Slack.Command (Command(..))
import Epicbot.Slack.Command as Command
import Epicbot.Web.Body as Body
import Epicbot.Web.Response as Response
import HTTPure as HTTPure

handle :: forall m. MonadAff m => Has Index m => HTTPure.Request -> m HTTPure.Response
handle { body } = do
  response <- executeCommand $ parseText $ body
  Response.jsonResponse response

executeCommand :: forall m. MonadAff m => Has Index m => String -> m CommandResponse
executeCommand text = case Command.parse text of
  Draft -> draftResponse
  Search searchTerm -> searchResponse searchTerm

draftResponse :: forall m. MonadAff m => Has Index m => m CommandResponse
draftResponse = do
  index <- grab
  items <- Index.random 5 index
  pure $ Slack.draftResponse items

searchResponse :: forall m. Has Index m => String -> m CommandResponse
searchResponse text = do
  index <- grab
  let
    result = Index.search text index
  pure $ Slack.searchResponse result

parseText :: String -> String
parseText = fromMaybe "" <<< Map.lookup "text" <<< Body.asMap
