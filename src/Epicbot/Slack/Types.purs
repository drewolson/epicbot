module Epicbot.Slack.Types
  ( Action(..)
  , Attachment(..)
  , CommandResponse(..)
  , InteractivePayload
  ) where

import Prelude
import Data.Argonaut.Core (Json, jsonEmptyObject)
import Data.Argonaut.Decode (class DecodeJson, JsonDecodeError, decodeJson, (.:?))
import Data.Argonaut.Encode (class EncodeJson, (~>), (~>?), (:=), (:=?))
import Data.Either (Either)
import Data.Maybe (Maybe, fromMaybe)

newtype CommandResponse
  = CommandResponse
  { attachments :: Maybe (Array Attachment)
  , deleteOriginal :: Maybe Boolean
  , responseType :: String
  , text :: String
  }

derive newtype instance Eq CommandResponse

derive newtype instance Ord CommandResponse

derive newtype instance Show CommandResponse

instance EncodeJson CommandResponse where
  encodeJson :: CommandResponse -> Json
  encodeJson (CommandResponse obj) =
    ("delete_original" :=? obj.deleteOriginal)
      ~>? ("attachments" :=? obj.attachments)
      ~>? ("text" := obj.text)
      ~> ("response_type" := obj.responseType)
      ~> jsonEmptyObject

newtype Attachment
  = Attachment
  { actions :: Maybe (Array Action)
  , callbackId :: Maybe String
  , imageUrl :: String
  , text :: Maybe String
  }

derive newtype instance Eq Attachment

derive newtype instance Ord Attachment

derive newtype instance Show Attachment

instance EncodeJson Attachment where
  encodeJson :: Attachment -> Json
  encodeJson (Attachment obj) =
    ("actions" :=? obj.actions)
      ~>? ("callback_id" :=? obj.callbackId)
      ~>? ("image_url" := obj.imageUrl)
      ~> ("text" := fromMaybe "" obj.text)
      ~> jsonEmptyObject

newtype Action
  = Action
  { name :: Maybe String
  , text :: Maybe String
  , type :: Maybe String
  , value :: Maybe String
  }

derive newtype instance Eq Action

derive newtype instance Ord Action

derive newtype instance Show Action

instance EncodeJson Action where
  encodeJson :: Action -> Json
  encodeJson (Action obj) =
    ("value" :=? obj.value)
      ~>? ("type" :=? obj.type)
      ~>? ("text" :=? obj.name)
      ~>? ("name" :=? obj.name)
      ~>? jsonEmptyObject

instance DecodeJson Action where
  decodeJson :: Json -> Either JsonDecodeError Action
  decodeJson json = do
    obj <- decodeJson json
    name <- obj .:? "name"
    text <- obj .:? "text"
    t <- obj .:? "type"
    value <- obj .:? "value"
    pure $ Action { name, text, type: t, value }

type InteractivePayload
  = { actions :: Array Action
    }
