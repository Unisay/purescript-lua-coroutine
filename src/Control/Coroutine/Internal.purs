module Control.Coroutine.Internal where

import Effect (Effect)

data Coroutine (input ∷ Type) (output ∷ Type)

foreign import create
  ∷ ∀ i o. (i → Effect o) → Effect (Coroutine i o)

foreign import resume
  ∷ ∀ i o r
  . Coroutine i o
  -- ^ Coroutine to resume.
  → i
  -- ^ Input value to resume the coroutine with.
  → (o → r)
  -- ^ Function to handle the output value.
  → (String → r)
  -- ^ Function to handle the coroutine's error.
  → Effect r

foreign import yield ∷ ∀ i o. o → Effect i

foreign import running ∷ ∀ i o r. (Coroutine i o → Boolean → r) → r

foreign import status ∷ ∀ i o. Coroutine i o → Effect String
