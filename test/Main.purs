module Test.Main where

import Prelude

import Control.Coroutine (Coroutine)
import Control.Coroutine as Coroutine
import Data.Array ((..))
import Data.Foldable (for_)
import Effect (Effect)
import Effect.Class.Console (log)
import Effect.Exception (error, throwException)

main ∷ Effect Unit
main = do
  producer ← makeProducer 10
  assertStatus producer Coroutine.Suspended
  result ← consume producer
  assertEq result 55
  assertStatus producer Coroutine.Dead

makeProducer ∷ Int → Effect (Coroutine Unit Int)
makeProducer stop = Coroutine.create \_ → do
  for_ (0 .. stop) \i → do
    log $ "Produced: " <> show i
    Coroutine.yield i
  pure (-1)

consume ∷ Coroutine Unit Int → Effect Int
consume co = go 0
  where
  go s = do
    r ← Coroutine.resume co unit
    if r < 0 then pure s
    else do
      let s' = s + r
      log $ "Consumed " <> show r <> ", sum is " <> show s'
      go s'

--------------------------------------------------------------------------------
-- Assertions ------------------------------------------------------------------

assertStatus ∷ ∀ i o. Coroutine i o → Coroutine.Status → Effect Unit
assertStatus co expected = do
  status ← Coroutine.status co
  assertEq status expected

assert ∷ String → Boolean → Effect Unit
assert _ true = pass
assert a false = throwException $ error $ "Assertion failed: " <> a

assertEq ∷ ∀ a. Eq a ⇒ Show a ⇒ a → a → Effect Unit
assertEq a b =
  assert ("LHS ≠ RHS:\nLHS: " <> show a <> "\nRHS: " <> show b) (a == b)
