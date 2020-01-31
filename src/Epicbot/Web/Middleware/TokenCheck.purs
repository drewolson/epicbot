module Epicbot.Web.Middleware.TokenCheck
  ( call
  ) where

import Prelude

import Control.Alt ((<|>))
import Control.Monad.Logger.Class (info)
import Control.Monad.Reader (ask)
import Data.Argonaut.Core (Json)
import Data.Argonaut.Decode (decodeJson, (.:))
import Data.Argonaut.Parser (jsonParser)
import Data.Either (Either, hush)
import Data.HashMap (HashMap)
import Data.HashMap as HashMap
import Data.Log.Tag (empty)
import Data.Maybe (Maybe(..))
import Epicbot.Token as Token
import Epicbot.App (ResponseM)
import Epicbot.Web.Body as Body
import HTTPure as HTTPure
import HTTPure.Utils (urlDecode)

call :: (HTTPure.Request -> ResponseM) -> HTTPure.Request -> ResponseM
call router req@{ body } = do
  { token } <- ask

  case tokenLookup body of
    Just val -> do
      equal <- Token.secureEqual val token

      if equal
        then router req
        else do
          info empty "Bad token"
          HTTPure.unauthorized

    Nothing -> do
      info empty "No token found"
      HTTPure.unauthorized

tokenLookup :: String -> Maybe String
tokenLookup body =
  let parsedBody = Body.asHashMap body
   in HashMap.lookup "token" parsedBody <|> tokenFromPayload parsedBody

tokenFromPayload :: HashMap String String -> Maybe String
tokenFromPayload parsedBody =
  parseToken =<< urlDecode <$> HashMap.lookup "payload" parsedBody

parseToken :: String -> Maybe String
parseToken payload = hush $ decodeToken =<< jsonParser payload

decodeToken :: Json -> Either String String
decodeToken json = do
  obj <- decodeJson json
  token <- obj .: "token"

  pure token
