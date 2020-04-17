module Epicbot.Index
  ( DocIndex
  , Index
  , findById
  , fromCards
  , new
  , random
  , search
  ) where

import Prelude
import Data.Array as Array
import Data.Function.Uncurried (Fn2, runFn2)
import Data.Map (Map)
import Data.Map as Map
import Data.Maybe (Maybe)
import Effect.Aff (Aff)
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (liftEffect)
import Effect.Uncurried (EffectFn2, runEffectFn2)
import Epicbot.Card (Card)
import Epicbot.Card as Card
import Epicbot.Random.Array (takeRandom)

newtype Index
  = Index
  { cards :: Map String Card
  , index :: DocIndex
  }

type Doc
  = { id :: String
    , name :: String
    }

type Result
  = { ref :: String
    , score :: Number
    }

foreign import data DocIndex :: Type

foreign import _addDoc :: EffectFn2 Doc DocIndex DocIndex

foreign import _newDocIndex :: DocIndex

foreign import _searchDoc :: Fn2 String DocIndex (Array Result)

new :: Index
new = Index { index: _newDocIndex, cards: Map.empty }

fromCards :: Array Card -> Aff Index
fromCards = Array.foldRecM (flip addCard) new

random :: forall m. MonadAff m => Int -> Index -> m (Array Card)
random n (Index { cards }) =
  liftAff
    $ takeRandom n
    $ Array.filter (not Card.dualSided)
    $ Array.fromFoldable
    $ Map.values
    $ cards

search :: String -> Index -> Array Card
search query (Index { index, cards }) = Array.mapMaybe resultToCard <<< searchDoc query $ index
  where
  resultToCard :: Result -> Maybe Card
  resultToCard result = Map.lookup result.ref cards

findById :: String -> Index -> Maybe Card
findById id (Index { cards }) = Map.lookup id cards

addCard :: Card -> Index -> Aff Index
addCard card (Index { index, cards }) = do
  index' <- addDoc (cardToDoc card) index
  let
    cards' = Map.insert card.id card cards
  pure $ Index { index: index', cards: cards' }

addDoc :: Doc -> DocIndex -> Aff DocIndex
addDoc doc index = liftEffect $ runEffectFn2 _addDoc doc index

searchDoc :: String -> DocIndex -> Array Result
searchDoc = runFn2 _searchDoc

cardToDoc :: Card -> Doc
cardToDoc { id, name } = { id, name }
