module Epicbot.Slack.Command
  ( Command(..)
  , parse
  ) where

import Prelude
import Data.Array as Array
import Data.Either (Either(..))
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.List (List)
import Data.String.CodePoints as CodePoints
import Text.Parsing.StringParser (Parser, runParser)
import Text.Parsing.StringParser.CodePoints (anyChar, eof, string, whiteSpace)
import Text.Parsing.StringParser.Combinators (many)

data Command
  = Draft
  | Search String

derive instance eqCommand :: Eq Command

derive instance genericCommand :: Generic Command _

instance showCommand :: Show Command where
  show = genericShow

charsToString :: List Char -> String
charsToString =
  CodePoints.fromCodePointArray
    <<< Array.fromFoldable
    <<< map CodePoints.codePointFromChar

anyString :: Parser String
anyString = charsToString <$> many anyChar

parseDraft :: Parser Command
parseDraft = Draft <$ (string "draft" <* whiteSpace <* eof)

parseCommand :: Parser Command
parseCommand = parseDraft

parse :: String -> Command
parse text = case runParser parseCommand text of
  Right command -> command
  Left _ -> Search text
