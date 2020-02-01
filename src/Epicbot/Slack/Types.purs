module Epicbot.Slack.Types
  ( Action(..)
  , Attachment(..)
  , CommandResponse(..)
  , InteractivePayload
  ) where

import Prelude

import Data.Argonaut.Core (Json, jsonEmptyObject)
import Data.Argonaut.Decode (class DecodeJson, decodeJson, (.:?))
import Data.Argonaut.Encode (class EncodeJson, (~>), (~>?), (:=), (:=?))
import Data.Either (Either)
import Data.Maybe (Maybe, fromMaybe)

newtype CommandResponse = CommandResponse
  { attachments    :: Maybe (Array Attachment)
  , deleteOriginal :: Maybe Boolean
  , responseType   :: String
  , text           :: String
  }

derive newtype instance eqCommandResponse :: Eq CommandResponse

derive newtype instance ordCommandResponse :: Ord CommandResponse

derive newtype instance showCommandResponse :: Show CommandResponse

instance encodeJsonCommandResponse :: EncodeJson CommandResponse where
  encodeJson :: CommandResponse -> Json
  encodeJson (CommandResponse obj) = do
    "delete_original" :=? obj.deleteOriginal
    ~>? "attachments" :=? obj.attachments
    ~>? "text" := obj.text
    ~> "response_type" := obj.responseType
    ~> jsonEmptyObject

newtype Attachment = Attachment
  { actions    :: Maybe (Array Action)
  , callbackId :: Maybe String
  , imageUrl   :: String
  , text       :: Maybe String
  }

derive newtype instance eqAttachment :: Eq Attachment

derive newtype instance ordAttachment :: Ord Attachment

derive newtype instance showAttachment :: Show Attachment

instance encodeJsonAttachment :: EncodeJson Attachment where
  encodeJson :: Attachment -> Json
  encodeJson (Attachment obj) = do
    "actions" :=? obj.actions
    ~>? "callback_id" :=? obj.callbackId
    ~>? "image_url" := obj.imageUrl
    ~> "text" := fromMaybe "" obj.text
    ~> jsonEmptyObject

newtype Action = Action
  { name  :: Maybe String
  , text  :: Maybe String
  , type  :: Maybe String
  , value :: Maybe String
  }

derive newtype instance eqAction :: Eq Action

derive newtype instance ordAction :: Ord Action

derive newtype instance showAction :: Show Action

instance encodeJsonAction :: EncodeJson Action where
  encodeJson :: Action -> Json
  encodeJson (Action obj) = do
    "value" :=? obj.value
    ~>? "type" :=? obj.type
    ~>? "text" :=? obj.name
    ~>? "name" :=? obj.name
    ~>? jsonEmptyObject

instance decodeJsonAction :: DecodeJson Action where
  decodeJson :: Json -> Either String Action
  decodeJson json = do
    obj <- decodeJson json
    name <- obj .:? "name"
    text <- obj .:? "text"
    t <- obj .:? "type"
    value <- obj .:? "value"

    pure $ Action { name, text, type: t, value }

type InteractivePayload =
  { actions :: Array Action
  }
