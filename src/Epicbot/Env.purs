module Epicbot.Env
  ( RequestFields
  , RequestEnv
  , Env
  , EnvFields
  ) where

import Data.Log.Level (LogLevel)
import Data.UUID (UUID)
import Epicbot.Index (Index)
import Epicbot.Slack.SigningSecret (SigningSecret)

type EnvFields r =
  ( index :: Index
  , port :: Int
  , signingSecret :: SigningSecret
  , logLevel :: LogLevel
  | r
  )

type RequestFields =
  ( requestId :: UUID
  )

type Env = { | EnvFields () }

type RequestEnv = { | EnvFields RequestFields }
