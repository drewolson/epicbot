module Epicbot.Web.Service.Command
  ( executeCommand
  , handle
  ) where

import Prelude

import Control.Monad.Reader (ask)
import Data.HashMap as HashMap
import Data.Maybe (fromMaybe)
import Effect.Aff.Class (liftAff)
import Epicbot.Index as Index
import Epicbot.Slack (CommandResponse)
import Epicbot.Slack as Slack
import Epicbot.App (App, ResponseM)
import Epicbot.Web.Body as Body
import Epicbot.Web.Response as Response
import HTTPure as HTTPure

handle :: HTTPure.Request -> ResponseM
handle { body } = do
  response <- executeCommand $ parseText $ body

  Response.jsonResponse response

executeCommand :: String -> App CommandResponse
executeCommand text = do
  if text == "draft"
    then draftResponse
    else searchResponse text

draftResponse :: App CommandResponse
draftResponse = do
  { index } <- ask
  items <- liftAff $ Index.random 5 index

  pure $ Slack.draftResponse items

searchResponse :: String -> App CommandResponse
searchResponse text = do
  { index } <- ask
  let result = Index.search text index

  pure $ Slack.searchResponse result

parseText :: String -> String
parseText = fromMaybe "" <<< HashMap.lookup "text" <<< Body.asHashMap
