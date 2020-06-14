module Epicbot.Slack.Command
  ( Command(..)
  , parse
  ) where

import Prelude
import Control.Alt ((<|>))
import Data.Array as Array
import Data.Either (Either(..))
import Data.List (List)
import Data.String.CodePoints as CodePoint
import Data.String.CodePoints as CodePoints
import Text.Parsing.StringParser (Parser, runParser)
import Text.Parsing.StringParser.CodePoints (anyChar, eof, string, whiteSpace)
import Text.Parsing.StringParser.Combinators (many)

data Command
  = Draft
  | Search String

charsToString :: List Char -> String
charsToString =
  CodePoints.fromCodePointArray
    <<< Array.fromFoldable
    <<< map CodePoint.codePointFromChar

anyString :: Parser String
anyString = charsToString <$> many anyChar

parseDraft :: Parser Command
parseDraft = Draft <$ (string "draft" *> many whiteSpace *> eof)

parseSearch :: Parser Command
parseSearch = Search <$> (anyString <* eof)

parseCommand :: Parser Command
parseCommand = parseDraft <|> parseSearch

parse :: String -> Command
parse text = case runParser parseCommand text of
  Right command -> command
  Left _ -> Search text
