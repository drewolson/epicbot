module Epicbot.Slack.Command
  ( Command(..)
  , parse
  ) where

import Prelude
import Data.Either (Either(..))
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Text.Parsing.StringParser (Parser, runParser)
import Text.Parsing.StringParser.CodePoints (eof, string, whiteSpace)

data Command
  = Draft
  | Search String

derive instance eqCommand :: Eq Command

derive instance genericCommand :: Generic Command _

instance showCommand :: Show Command where
  show :: Command -> String
  show = genericShow

parseDraft :: Parser Command
parseDraft = Draft <$ (string "draft" <* whiteSpace <* eof)

parseCommand :: Parser Command
parseCommand = parseDraft

parse :: String -> Command
parse text = case runParser parseCommand text of
  Right command -> command
  Left _ -> Search text
