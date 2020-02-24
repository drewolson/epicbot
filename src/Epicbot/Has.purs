module Epicbot.Has
  ( class Has
  , grab
  ) where

import Prelude

class Monad m <= Has a m where
  grab :: m a
