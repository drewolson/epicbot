module Epicbot.Card
  ( Card
  , dualSided
  ) where

type Card =
  { id :: String
  , name :: String
  , urls :: Array String
  }

dualSided :: Card -> Boolean
dualSided { urls: [ _, _ ] } = true

dualSided _ = false
