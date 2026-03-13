{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use newtype instead of data" #-}
module Queue1 (Queue, mtq, ismt, addq, remq) where

---- Interface ----------------
mtq  :: Queue a                  -- empty queue
ismt :: Queue a -> Bool          -- is the queue empty?
addq :: a -> Queue a -> Queue a  -- add element to front of queue
remq :: Queue a -> (a, Queue a)  -- remove element from back of queue;
                                 --   produces error "Can't remove an element
                                 --   from an empty queue" on empty

---- Implementation -----------

{- In this implementation, a queue is represented as an ordinary list.
The "front" of the queue is at the head of the list, and the "back" of
the queue is at the end of the list.
-}

data Queue a = Queue1 [a] deriving (Show)

mtq = Queue1 []

{-
ghci> mtq
Queue1 []
-}

ismt (Queue1 xs) = null xs

{-
ghci> ismt mtq
True
ghci> ismt (addq 5 mtq)
False
-}

addq x (Queue1 xs) = Queue1 (xs ++ [x])

{-
ghci> addq 1 mtq
Queue1 [1]
ghci> addq 2 (addq 1 mtq)
Queue1 [1,2]
ghci> addq 3 (addq 2 (addq 1 mtq))
Queue1 [1,2,3]
-}

remq (Queue1 []) = error "Can't remove an element from an empty queue"
remq (Queue1 (x:xs)) = (x, Queue1 xs)

{-
ghci> remq (addq 1 mtq)
(1,Queue1 [])
ghci> remq (addq 2 (addq 1 mtq))
(1,Queue1 [2])
ghci> remq (addq 3 (addq 2 (addq 1 mtq)))
(1,Queue1 [2,3])
ghci> remq mtq
*** Exception: Can't remove an element from an empty queue
CallStack (from HasCallStack):
  error, called at Queue1.hs:25:20 in main:Queue1
-}

-- I Chained Operations Together To See If It Would Work
{-
ghci> let q1 = addq 1 mtq
ghci> let q2 = addq 2 q1
ghci> let q3 = addq 3 q2
ghci> ismt q3
False
ghci> remq q3
(1,Queue1 [2,3])
ghci> let (_, q4) = remq q3
ghci> remq q4
(2,Queue1 [3])
ghci> let (_, q5) = remq q4
ghci> remq q5
(3,Queue1 [])
ghci> ismt q5
False
-}