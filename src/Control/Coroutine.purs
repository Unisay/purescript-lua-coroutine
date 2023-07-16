module Control.Coroutine
  ( module Reexport
  , Status(..)
  , create
  , status
  , resume
  , yield
  ) where

import Prelude

import Control.Coroutine.Internal (Coroutine)
import Control.Coroutine.Internal (Coroutine) as Reexport
import Control.Coroutine.Internal as Internal
import Effect (Effect)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Exception (error, throwException)

-- running ∷ ∀ (i ∷ Type) (o ∷ Type) (r ∷ Type). (Coroutine i o → Boolean → r) → r
-- running = Internal.running \coroutine isMain → Tuple coroutine isMain

data Status
  = Running
  -- ^ the coroutine is running (that is, it called status);
  | Suspended
  -- ^ the coroutine is suspended in a call to yield,
  -- or if it has not started running yet;
  | Normal
  -- ^ "normal" if the coroutine is active but not running
  -- (that is, it has resumed another coroutine);
  | Dead

instance showStatus ∷ Show Status where
  show Running = "running"
  show Suspended = "suspended"
  show Normal = "normal"
  show Dead = "dead"

instance eqStatus ∷ Eq Status where
  eq s1 s2 = show s1 == show s2

create ∷ ∀ i o m. MonadEffect m ⇒ (i → Effect o) → m (Coroutine i o)
create f = liftEffect (Internal.create f)

status ∷ ∀ i o m. MonadEffect m ⇒ Coroutine i o → m Status
status co = liftEffect do
  s ← Internal.status co
  case s of
    "running" → pure Running
    "suspended" → pure Suspended
    "normal" → pure Normal
    "dead" → pure Dead
    unknown → throwException $ error
      $ "Control.Coroutine.status: Unknown status value " <> unknown

resume ∷ ∀ i o m. MonadEffect m ⇒ Coroutine i o → i → m o
resume co i = liftEffect do
  effectO ← Internal.resume co i pure \msg → throwException (error msg)
  effectO

yield ∷ ∀ i o m. MonadEffect m ⇒ o → m i
yield o = liftEffect (Internal.yield o)
