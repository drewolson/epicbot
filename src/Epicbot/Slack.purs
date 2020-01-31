module Epicbot.Slack
  ( cardResponse
  , draftResponse
  , idFromPayload
  , searchResponse
  , module Epicbot.Slack.Types
  ) where

import Prelude

import Data.Array ((!!))
import Data.Array as Array
import Data.Maybe (Maybe(..), fromMaybe)
import Epicbot.Card (Card)
import Epicbot.Slack.Types (Action(..), Attachment(..), CommandResponse(..), InteractivePayload)

idFromPayload :: InteractivePayload -> Maybe String
idFromPayload { actions } = do
  Action action <- Array.head actions

  action.value

draftResponse :: Array Card -> CommandResponse
draftResponse cards = CommandResponse
  { responseType: "in_channel"
  , text: "Draft - what would you pick?"
  , attachments: Just $ urlsToAttachments =<< map _.urls cards
  , deleteOriginal: Nothing
  }

searchResponse :: Array Card -> CommandResponse
searchResponse [] = CommandResponse
  { responseType: "ephemeral"
  , text: "No card found"
  , attachments: Nothing
  , deleteOriginal: Nothing
  }
searchResponse [card] = cardResponse card
searchResponse cards = CommandResponse
  { responseType: "ephemeral"
  , text: "Please select a card"
  , attachments: Just (cardToButton <$> Array.take 3 cards)
  , deleteOriginal: Nothing
  }

cardResponse :: Card -> CommandResponse
cardResponse card = CommandResponse
  { responseType: "in_channel"
  , text: card.name
  , attachments: Just (urlsToAttachments $ Array.take 2 $ card.urls)
  , deleteOriginal: Just true
  }

cardToButton :: Card -> Attachment
cardToButton card = Attachment
  { text: Just card.name
  , imageUrl: fromMaybe "" $ card.urls !! 0
  , callbackId: Just "select_card"
  , actions: Just
    [ Action
      { name: Just "select"
      , text: Just "Select"
      , type: Just "button"
      , value: Just card.id
      }
    ]
  }

urlsToAttachments :: Array String -> Array Attachment
urlsToAttachments [url] =
  [ Attachment { text: Nothing, imageUrl: url, callbackId: Nothing, actions: Nothing }
  ]
urlsToAttachments [front, back] =
  [ Attachment { text: Just "Front", imageUrl: front, callbackId: Nothing, actions: Nothing }
  , Attachment { text: Just "Back", imageUrl: back, callbackId: Nothing, actions: Nothing }
  ]
urlsToAttachments _ = []
