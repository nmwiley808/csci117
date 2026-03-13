-- CSci 117, Lab 3:  ADTs and Type Classes
-- Student Name: Noah Wiley
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use if" #-}

import Data.List (sort)
import Queue1
--import Queue2
import Fraction

---------------- Part 1: Queue client

-- Queue operations (A = add, R = remove)
data Qops a = A a | R

-- Perform a list of queue operations on an emtpy queue,
-- returning the list of the removed elements
perf :: [Qops a] -> [a]
perf ops = process ops mtq
    where
        process [] _ = []
        process (A x : xs) q = process xs (addq x q)
        process (R : xs) q = case ismt q of
            True -> error "Can't remove from an empty queue"
            False -> let (x, q') = remq q in x : process xs q'

-- Test the above functions thouroughly. For example, here is one test:
-- perf [A 3, A 5, R, A 7, R, A 9, A 11, R, R, R] ---> [3,5,7,9,11]

{-
ghci> perf [A 3, A 5, R, A 7, R, A 9, A 11, R, R, R]
[3,5,7,9,11]
ghci> perf [A 1, A 2, A 3, R, R, R]
[1,2,3]
ghci> perf [R]
*** Exception: Can't remove from an empty queue
CallStack (from HasCallStack):
  error, called at lab3.hs:24:21 in main:Main
-}

---------------- Part 2: Using typeclass instances for fractions

-- Construct a fraction, producing an error if it fails
fraction :: Integer -> Integer -> Fraction
fraction a b = case frac a b of
             Nothing -> error "Illegal fraction"
             Just fr -> fr

{-
ghci> fraction 4 5
4/5
ghci> fraction (-4) 5
-4/5
ghci> fraction 4 8
1/2
ghci> fraction 5 0
*** Exception: Illegal fraction
CallStack (from HasCallStack):
  error, called at lab3.hs:46:25 in main:Main
-}

-- Calculate the average of a list of fractions
-- Give the error "Empty average" if xs is empty
average :: [Fraction] -> Fraction
average [] = error "Empty average"
average xs = sum xs * fraction 1 (fromIntegral (length xs))
-- Some lists of fractions

list1 = [fraction n (n+1) | n <- [1..20]]
list2 = [fraction 1 n | n <- [1..20]]
--list3 = zipWith (+) list1 list2
list3 = zipWith (+) list1 list2
list4 = zipWith (*) list1 list2
list5 = map negate list1

-- Make up several more lists for testing

{-
ghci> average list1
17955695/20692672
ghci> average list2
11167027/62078016
ghci> average list3
22/21
ghci> average list4
2736977/20692672
ghci> average list5
-17955695/20692672
-}

-- Show examples testing the functions sort, sum, product, maximum, minimum,
-- and average on a few lists of fractions each. Think about how these library
-- functions can operate on Fractions, even though they were written long ago
sorted1 = sort list1
sum1 = sum list1
product1 = product list1
max1 = maximum list1
min1 = minimum list1
avg1 = average list1

{-
ghci> sorted1
[1/2,2/3,3/4,4/5,5/6,6/7,7/8,8/9,9/10,10/11,11/12,12/13,13/14,14/15,15/16,16/17,17/18,18/19,19/20,20/21]
ghci> sum1
89778475/5173168
ghci> product1
1/21
ghci> max1
20/21
ghci> min1
1/2
ghci> avg1
17955695/20692672
-}
