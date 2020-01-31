module Epicbot.Env
  ( RequestFields
  , RequestEnv
  , Env
  , EnvFields
  ) where

import Data.Log.Level (LogLevel)
import Data.UUID (UUID)
import Epicbot.Index (Index)
import Epicbot.OnlineStatus (OnlineStatus)
import Epicbot.Token (Token)

type EnvFields r =
  ( index        :: Index
  , onlineStatus :: OnlineStatus
  , port         :: Int
  , token        :: Token
  , logLevel     :: LogLevel
  | r
  )

type RequestFields =
  ( requestId :: UUID
  )

type Env = { | EnvFields () }

type RequestEnv = { | EnvFields RequestFields }
