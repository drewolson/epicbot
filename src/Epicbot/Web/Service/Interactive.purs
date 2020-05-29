module Epicbot.Web.Service.Interactive
  ( handle
  ) where

import Prelude
import Control.Monad.Logger.Class (class MonadLogger)
import Control.Monad.Logger.Class as Logger
import Data.Argonaut.Decode (decodeJson)
import Data.Argonaut.Parser (jsonParser)
import Data.Either (Either(..), note)
import Data.Map as Map
import Data.Map (empty)
import Effect.Aff.Class (class MonadAff)
import Epicbot.Capability.Has (class Has, grab)
import Epicbot.Index (Index)
import Epicbot.Index as Index
import Epicbot.Slack (CommandResponse, InteractivePayload)
import Epicbot.Slack as Slack
import Epicbot.Web.Body as Body
import Epicbot.Web.Response as Response
import HTTPure as HTTPure
import HTTPure.Utils (urlDecode)

handle ::
  forall m.
  MonadLogger m =>
  MonadAff m =>
  Has Index m =>
  HTTPure.Request ->
  m HTTPure.Response
handle { body } = do
  index <- grab
  case result index of
    Left error -> do
      Logger.error empty error
      HTTPure.notFound
    Right response -> Response.jsonResponse response
  where
  result :: Index -> Either String CommandResponse
  result index = executeInteractive index =<< decodePayload body

decodePayload :: String -> Either String InteractivePayload
decodePayload body = do
  encodedPayload <- note "No payload found in body" $ Map.lookup "payload" $ Body.asMap body
  let
    payload = urlDecode encodedPayload
  decodeJson =<< jsonParser payload

executeInteractive :: Index -> InteractivePayload -> Either String CommandResponse
executeInteractive index payload = do
  id <- note "No id found in payload" $ Slack.idFromPayload payload
  card <- note ("Id " <> id <> " not found in index") $ Index.findById id index
  pure $ Slack.cardResponse card
