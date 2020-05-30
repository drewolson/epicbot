module Epicbot.Web.Router
  ( route
  ) where

import Prelude
import Data.Either (Either(..))
import Data.Foldable (oneOf)
import Epicbot.Capability.MonadApp (class MonadApp)
import Epicbot.Web.Service.Command as CommandService
import Epicbot.Web.Service.Interactive as InteractiveService
import HTTPure as HTTPure
import HTTPure.Request as Request
import Routing as Routing
import Routing.Match (Match, end, lit, root)

data Route
  = Command
  | Interactive

routeMatch :: Match Route
routeMatch =
  oneOf
    [ pure Command
    , Interactive <$ lit "interactive"
    ]

router :: Match Route
router = root *> routeMatch <* end

route :: forall m. MonadApp m => HTTPure.Request -> m HTTPure.Response
route req = case Routing.match router $ Request.fullPath req of
  Right Command -> CommandService.handle req
  Right Interactive -> InteractiveService.handle req
  Left _ -> HTTPure.notFound
