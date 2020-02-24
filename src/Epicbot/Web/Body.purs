module Epicbot.Web.Body
  ( asMap
  ) where

import Prelude

import Control.Alt ((<|>))
import Data.Either (hush)
import Data.Foldable (class Foldable)
import Data.Foldable as Foldable
import Data.Map (Map)
import Data.Map as Map
import Data.List (List(..))
import Data.List as List
import Data.Maybe (Maybe(..), fromMaybe)
import Data.String.CodeUnits as CodeUnits
import Data.Tuple (Tuple(..))
import Text.Parsing.StringParser (Parser, runParser, try)
import Text.Parsing.StringParser.CodePoints (anyChar, oneOf, eof, string)
import Text.Parsing.StringParser.Combinators (lookAhead, manyTill, sepBy)

asString :: forall f. Foldable f => f Char -> String
asString = Foldable.foldMap CodeUnits.singleton

endOfEntry :: Parser Unit
endOfEntry = lookAhead $ (oneOf ['=', '&'] *> pure unit) <|> eof

parseToken :: Parser String
parseToken = asString <$> manyTill anyChar endOfEntry

parseGoodEntry :: Parser (Tuple String String)
parseGoodEntry = do
  key <- parseToken <* string "="
  val <- parseToken

  pure $ Tuple key val

parseBadEntry :: Parser Unit
parseBadEntry = parseToken *> pure unit

parseEntry :: Parser (Maybe (Tuple String String))
parseEntry =
  try (Just <$> parseGoodEntry) <|> (parseBadEntry *> pure Nothing)

parseQuery :: Parser (List (Tuple String String))
parseQuery = do
  entries <- sepBy parseEntry $ string "&"

  pure $ List.catMaybes entries

asMap :: String -> Map String String
asMap = Map.fromFoldable <<< fromMaybe Nil <<< hush <<< runParser parseQuery
