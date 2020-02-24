module Epicbot.Web.Service.Command
  ( executeCommand
  , handle
  ) where

import Prelude

import Data.Map as Map
import Data.Maybe (fromMaybe)
import Effect.Aff.Class (liftAff)
import Epicbot.Has (grab)
import Epicbot.Index as Index
import Epicbot.MonadApp (class MonadApp)
import Epicbot.Slack (CommandResponse)
import Epicbot.Slack as Slack
import Epicbot.Web.Body as Body
import Epicbot.Web.Response as Response
import HTTPure as HTTPure

handle :: forall m. MonadApp m => HTTPure.Request -> m HTTPure.Response
handle { body } = do
  response <- executeCommand $ parseText $ body

  Response.jsonResponse response

executeCommand :: forall m. MonadApp m => String -> m CommandResponse
executeCommand text = do
  if text == "draft"
    then draftResponse
    else searchResponse text

draftResponse :: forall m. MonadApp m => m CommandResponse
draftResponse = do
  index <- grab
  items <- liftAff $ Index.random 5 index

  pure $ Slack.draftResponse items

searchResponse :: forall m. MonadApp m => String -> m CommandResponse
searchResponse text = do
  index <- grab
  let result = Index.search text index

  pure $ Slack.searchResponse result

parseText :: String -> String
parseText = fromMaybe "" <<< Map.lookup "text" <<< Body.asMap
