module Epicbot.Web.Router
  ( Route(..)
  , route
  , router
  ) where

import Prelude hiding ((/))
import Data.Either (Either(..))
import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)
import Epicbot.Capability.MonadApp (class MonadApp)
import Epicbot.Web.Service.Command as CommandService
import Epicbot.Web.Service.Interactive as InteractiveService
import HTTPure as HTTPure
import HTTPure.Request as Request
import Routing.Duplex (RouteDuplex', parse, root)
import Routing.Duplex.Generic (noArgs, sum)
import Routing.Duplex.Generic.Syntax ((/))

data Route
  = Command
  | Interactive

derive instance eqRoute :: Eq Route

derive instance genericRoute :: Generic Route _

instance showRoute :: Show Route where
  show = genericShow

router :: RouteDuplex' Route
router =
  root
    $ sum
        { "Command": noArgs
        , "Interactive": "interactive" / noArgs
        }

route :: forall m. MonadApp m => HTTPure.Request -> m HTTPure.Response
route req = case parse router $ Request.fullPath req of
  Right Command -> CommandService.handle req
  Right Interactive -> InteractiveService.handle req
  Left _ -> HTTPure.notFound
