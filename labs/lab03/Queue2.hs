module Queue2 (Queue, mtq, ismt, addq, remq) where

---- Interface ----------------
mtq  :: Queue a                  -- empty queue
ismt :: Queue a -> Bool          -- is the queue empty?
addq :: a -> Queue a -> Queue a  -- add element to front of queue
remq :: Queue a -> (a, Queue a)  -- remove element from back of queue;
                                 --   produces error "Can't remove an element
                                 --   from an empty queue" on empty

--- Implementation -----------

{- In this implementation, a queue is represented as a pair of lists.
The "front" of the queue is at the head of the first list, and the
"back" of the queue is at the HEAD of the second list.  When the
second list is empty and we want to remove an element, we REVERSE the
elements in the first list and move them to the back, leaving the
first list empty. We can now process the removal request in the usual way.
-}

data Queue a = Queue2 [a] [a] deriving (Show)

mtq = Queue2 [] []

{-
ghci> mtq
Queue1 []
-}

ismt (Queue2 f b) = null f && null b

{-
ghci> ismt mtq
True
ghci> ismt (addq 5 mtq)
False
-}

addq x (Queue2 f b) = Queue2 f (x:b)

{-
ghci> addq 1 mtq
Queue1 [1]
ghci> addq 2 (addq 1 mtq)
Queue1 [1,2]
ghci> addq 3 (addq 2 (addq 1 mtq))
Queue1 [1,2,3]
-}

remq (Queue2 [] []) = error "Cant's remove an element from an empty queue"
remq (Queue2 [] b)= remq (Queue2 (reverse b) [])
remq (Queue2 (x:xs) b) = (x, Queue2 xs b)

{-
ghci> remq (addq 1 mtq)
(1,Queue2 [] [])
ghci> remq (addq 2 (addq 1 mtq))
(1,Queue2 [2] [])
ghci> remq (addq 3 (addq 2 (addq 1 mtq)))
(1,Queue2 [2,3] [])
ghci> remq mtq
*** Exception: Cant's remove an element from an empty queue
CallStack (from HasCallStack):
  error, called at Queue2.hs:26:23 in main:Queue2
-}

-- I Chained Operations Together To Test

{-
ghci> let q1 = addq 1 mtq
ghci> let q2 = addq 2 q1
ghci> let q3 = addq 3 q2
ghci> ismt q3
False
ghci> remq q3
(1,Queue2 [2,3] [])
ghci> let (_, q4) = remq q3
ghci> remq q4
(2,Queue2 [3] [])
ghci> let (_, q5) = remq q4
ghci> remq q5
(3,Queue2 [] [])
ghci> ismt q5
False
-}