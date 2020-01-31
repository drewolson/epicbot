module Epicbot.Html.Parser
  ( parseCards
  ) where

import Epicbot.Card (Card)

foreign import parseCards :: String -> Array Card
