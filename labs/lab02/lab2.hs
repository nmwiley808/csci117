-- CSci 117, Lab 2:  Functional techniques, iterators/accumulators,
-- and higher-order functions. Make sure you test all of your functions,
-- including key tests and their output in comments after your code.
-- Student Name: Noah Wiley
---- Part 1: Basic structural recursion ----------------

-- 1. Merge sort

-- Deal a list into two (almost) equal-sizes lists by alternating elements
-- For example, deal [1,2,3,4,5,6,7] = ([1,3,5,7], [2,4,6])
-- and          deal   [2,3,4,5,6,7] = ([2,4,6], [3,5,7])
-- Hint: notice what's happening between the answers to deal [2..7] and
-- deal (1:[2..7]) above to get an idea of how to approach the
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use foldr" #-}
deal :: [a] -> ([a],[a])
deal [] = ([],[])
deal (x:xs) = let (ys,zs) = deal xs
              in (x:zs, ys)

{-
ghci> deal [10..20]
([10,12,14,16,18,20],[11,13,15,17,19])
ghci> deal [1..8]
([1,3,5,7],[2,4,6,8])
 -}

-- Now implement merge and mergesort (ms), and test with some
-- scrambled lists to gain confidence that your code is correct
merge :: Ord a => [a] -> [a] -> [a]
merge [] ys = ys
merge xs [] = xs
merge (x:xs) (y:ys)
  | x <= y = x : merge xs (y:ys)
  | x > y  = y : merge (x:xs) ys

ms :: Ord a => [a] -> [a]
ms [] = []
ms [x] = [x]
ms xs = merge(ms left) (ms right)   -- general case: deal, recursive call, merge
        where (left, right) = deal xs

{-
ghci> ms [45,30,50,25,100]
[25,30,45,50,100]
ghci> ms [90,75,30,25,10,5]
[5,10,25,30,75,90]
-}

-- 2. A backward list data structure
-- Back Lists: Lists where elements are added to the back ("snoc" == rev "cons")
-- For example, the list [1,2,3] is represented as Snoc (Snoc (Snoc Nil 1) 2) 3
data BList a = Nil | Snoc (BList a) a deriving (Show,Eq)

-- Add an element to the beginning of a BList, like (:) does
cons :: a -> BList a -> BList a
cons x xs = Snoc xs x

{-
ghci> cons 1 (Snoc (Snoc Nil 3) 2)
Snoc (Snoc (Snoc Nil 3) 2) 1
-}

-- Convert a usual list into a BList (hint: use cons in the recursive case)
toBList :: [a] -> BList a
toBList [] = Nil
toBList(x:xs) = cons x (toBList xs)

{-
ghci> toBList [1,2,3]
Snoc (Snoc (Snoc Nil 3) 2) 1
ghci> toBList [5,10,15]
Snoc (Snoc (Snoc Nil 15) 10) 5
-}

-- Add an element to the end of an ordinary list
snoc :: [a] -> a -> [a]
snoc xs x = xs ++ [x]

{-
ghci> snoc [1,2] 5
[1,2,5]
ghci> snoc [5,10] 20
[5,10,20]
-}

-- Convert a BList into an ordinary list (hint: use snoc in the recursive case)
fromBList :: BList a -> [a]
fromBList Nil = []
fromBList(Snoc xs x) = x : fromBList xs

{-
ghci> let backwardList = Snoc (Snoc (Snoc Nil 1) 2) 3
ghci> let regularList = fromBList backwardList
ghci> fromBList backwardList
[3,2,1]
-}

-- 3. A binary tree data structure
data Tree a = Empty | Node a (Tree a) (Tree a) deriving (Show, Eq)

-- Count number of Empty's in the tree
num_empties :: Tree a -> Int
num_empties Empty = 1
num_empties (Node _ left right) = num_empties left + num_empties right

{-
ghci> let myTree = Node 8 (Node 2 Empty Empty) (Node 3 (Node 5 Empty Empty) Empty)
ghci> num_empties myTree
5
-}

-- Count number of Node's in the tree
num_nodes :: Tree a -> Int
num_nodes Empty = 0
num_nodes (Node _ left right) = 1 + num_nodes left + num_nodes right

{-
ghci> let myTree = Node 8 (Node 2 Empty Empty) (Node 3 (Node 5 Empty Empty) Empty)
ghci> num_nodes myTree
4
-}

-- Insert a new node in the leftmost spot in the tree
insert_left :: a -> Tree a -> Tree a
insert_left x Empty = Node x Empty Empty
insert_left x (Node v left right) = Node v (insert_left x left) right

{-
ghci> insert_left 10 myTree
Node 8 (Node 2 (Node 10 Empty Empty) Empty) (Node 3 (Node 5 Empty Empty) Empty)
-}

-- Insert a new node in the rightmost spot in the tree
insert_right :: a -> Tree a -> Tree a
insert_right x Empty = Node x Empty Empty
insert_right x (Node v left right) = Node v left (insert_right x right)

{-
ghci> insert_right 10 myTree
Node 8 (Node 2 Empty Empty) (Node 3 (Node 5 Empty Empty) (Node 10 Empty Empty))
-}

-- Add up all the node values in a tree of numbers
sum_nodes :: Num a => Tree a -> a
sum_nodes Empty = 0
sum_nodes (Node v left right) = v + sum_nodes left + sum_nodes right
{-
ghci> sum_nodes myTree
18
-}

-- Produce a list of the node values in the tree via an inorder traversal
-- Feel free to use concatenation (++)
inorder :: Tree a -> [a]
inorder Empty = []
inorder (Node v left right) = inorder left ++ [v] ++ inorder right

{-
ghci> inorder myTree
[2,8,5,3]
-}

-- 4. A different, leaf-based tree data structure
data Tree2 a = Leaf a | Node2 a (Tree2 a) (Tree2 a) deriving Show

-- Count the number of elements in the tree (leaf or node)
num_elts :: Tree2 a -> Int
num_elts (Leaf _) = 1
num_elts (Node2 _ left right) = 1 + num_elts left + num_elts right

{-
ghci> let tree2 = Node2 8 (Leaf 2) (Node2 3 (Leaf 5) (Leaf 7))
ghci> num_elts tree2
5
-}

-- Add up all the elements in a tree of numbers
sum_nodes2 :: Num a => Tree2 a -> a
sum_nodes2 (Leaf x) = x
sum_nodes2 (Node2 x left right) = x + sum_nodes2 left + sum_nodes2 right

{-
ghci> let tree2 = Node2 8 (Leaf 2) (Node2 3 (Leaf 5) (Leaf 7))
ghci> sum_nodes2 tree2
25
-}

-- Produce a list of the elements in the tree via an inorder traversal
-- Again, feel free to use concatenation (++)
inorder2 :: Tree2 a -> [a]
inorder2 (Leaf x) = [x]
inorder2 (Node2 x left right) = inorder2 left ++ [x] ++ inorder2 right

{-
ghci> inorder2 tree2
[2,8,5,3,7]
-}

-- Convert a Tree2 into an equivalent Tree1 (with the same elements)
conv21 :: Tree2 a -> Tree a
conv21 (Leaf x) = Node x Empty Empty
conv21 (Node2 x left right) = Node x (conv21 left) (conv21 right)

{-
ghci> conv21 tree2
Node 8 (Node 2 Empty Empty) (Node 3 (Node 5 Empty Empty) (Node 7 Empty Empty))
-}

---- Part 2: Iteration and Accumulators ----------------


-- Both toBList and fromBList from Part 1 Problem 2 are O(n^2) operations.
-- Reimplement them using iterative helper functions (locally defined using
-- a 'where' clause) with accumulators to make them O(n)
toBList' :: [a] -> BList a
toBList' xs = toB_List xs Nil
        where
            toB_List :: [a] -> BList a -> BList a
            toB_List [] a = a
            toB_List (x:xs) a = toB_List xs (Snoc a x)

{-
ghci> toBList' [1,2,3]
Snoc (Snoc (Snoc Nil 1) 2) 3
ghci> toBList' [10,15,20]
Snoc (Snoc (Snoc Nil 10) 15) 20
-}

fromBList' :: BList a -> [a]
fromBList' xs = fromB_List xs []
           where
            fromB_List :: BList a -> [a] -> [a]
            fromB_List Nil a = a
            fromB_List (Snoc list x) a = fromB_List list (x:a)

{-
ghci> let backwardList = Snoc (Snoc (Snoc Nil 1) 2) 3
ghci> fromBList backwardList
[3,2,1]
-}

-- Even tree functions that do multiple recursive calls can be rewritten
-- iteratively using lists of trees and an accumulator. For example,
sum_nodes' :: Num a => Tree a -> a
sum_nodes' t = sum_nodes_it [t] 0 where
  sum_nodes_it :: Num a => [Tree a] -> a -> a
  sum_nodes_it [] a = a
  sum_nodes_it (Empty:ts) a = sum_nodes_it ts a
  sum_nodes_it (Node n t1 t2:ts) a = sum_nodes_it (t1:t2:ts) (n+a)

{-
ghci> let myTree = Node 8 (Node 2 Empty Empty) (Node 3 (Node 5 Empty Empty) Empty)
ghci> sum_nodes' myTree
18
ghci> let sTree = Node 17 (Node 5 Empty Empty) (Node 3 (Node 10 Empty Empty) Empty)
ghci> sum_nodes' sTree
35
-}

-- Use the same technique to convert num_empties, num_nodes, and sum_nodes2
-- into iterative functions with accumulators

num_empties' :: Tree a -> Int
num_empties' t = num_empties_it [t] 0
    where num_empties_it :: [Tree a] -> Int -> Int
          num_empties_it [] a = a
          num_empties_it (Empty:ts) a = num_empties_it ts (a+1)
          num_empties_it (Node n leftNode rightNode:ts) a = num_empties_it (leftNode:rightNode:ts) a

{-
ghci> let myTree = Node 8 (Node 2 Empty Empty) (Node 3 (Node 5 Empty Empty) Empty)
ghci> num_empties' myTree
5
-}

num_nodes' :: Tree a -> Int
num_nodes' t = num_nodes_it [t] 0
  where num_nodes_it :: [Tree a] -> Int -> Int
        num_nodes_it [] a = a
        num_nodes_it (Node n leftNode rightNode:ts) a = num_nodes_it (leftNode:rightNode:ts) (a+1)

{-
ghci> num_nodes' myTree
4
-}

sum_nodes2' :: Num a => Tree2 a -> a
sum_nodes2' t = sum_nodes2_it [t] 0
    where
        sum_nodes2_it [] acc = acc
        sum_nodes2_it (Leaf x:ts) acc = sum_nodes2_it ts (x + acc)
        sum_nodes2_it (Node2 x left right:ts) acc = sum_nodes2_it (left:right:ts) (x + acc)

{-
ghci> sum_nodes2' tree2
25
-}

-- Use the technique once more to rewrite inorder2 so it avoids doing any
-- concatenations, using only (:).
-- Hint 1: (:) produces lists from back to front, so you should do the same.
-- Hint 2: You may need to get creative with your lists of trees to get the
-- right output.

inorder2' :: Tree2 a -> [a]
inorder2' t = inorder2_it [t] []
    where
        inorder2_it [] acc = acc
        inorder2_it (Leaf x:ts) acc = inorder2_it ts (x:acc)
        inorder2_it (Node2 x left right:ts) acc = inorder2_it (right:left:ts) (x:acc)

{-
ghci> inorder2' tree2
[2,5,7,3,8]
-}
---- Part 3: Higher-order functions ----------------

-- The functions map, all, any, filter, dropWhile, takeWhile, and break
-- from the Prelude are all higher-order functions. Reimplement them here
-- as list recursions. break should process each element of the list at
-- most once. All functions should produce the same output as the originals.

my_map :: (a -> b) -> [a] -> [b]
my_map _ [] = []
my_map f (x:xs) = f x : my_map f xs

{-
ghci> my_map (+1) [1,2,3]
[2,3,4]
-}

my_all :: (a -> Bool) -> [a] -> Bool
my_all _ [] = True
my_all f (x:xs) = f x && my_all f xs

{-
ghci> my_map (+1) [1,2,3]
[2,3,4]
ghci> my_all even [2,4,6,8]
True
ghci> my_all even [2,3,4,6,8]
False
-}

my_any :: (a -> Bool) -> [a] -> Bool
my_any _ [] = False
my_any f (x:xs) = f x || my_any f xs

{-
ghci> my_any even [2,3,5]
True
ghci> my_any even [1,3,5]
False
-}

my_filter :: (a -> Bool) -> [a] -> [a]
my_filter _ [] = []
my_filter p (x:xs)
    | p x    = x : my_filter p xs
    | otherwise = my_filter p xs
{-
ghci> my_filter odd [1,2,3,4,5,6,7,8,9,10]
[1,3,5,7,9]
ghci> my_filter even [1,2,3,4,5,6,7,8,9,10]
[2,4,6,8,10]
-}

my_dropWhile :: (a -> Bool) -> [a] -> [a]
my_dropWhile _ [] = []
my_dropWhile p (x:xs)
    | p x       = my_dropWhile p xs
    | otherwise = x:xs
{-
ghci> my_dropWhile (<5) [1,2,3,4,5,6,7,8,9,10]
[5,6,7,8,9,10]
-}

my_takeWhile :: (a -> Bool) -> [a] -> [a]
my_takeWhile _ [] = []
my_takeWhile p (x:xs)
    | p x        = x : my_takeWhile p xs
    | otherwise = []

{-
ghci> my_takeWhile (<4) [1,2,3,4,5]
[1,2,3]
ghci> my_takeWhile (<6) [1,2,3,4,5,6,7,8]
[1,2,3,4,5]
-}

my_break :: (a -> Bool) -> [a] -> ([a], [a])
my_break _ [] = ([], [])
my_break p (x:xs)
    | p x   = ([], x:xs)
    | otherwise = let (ys, zs) = my_break p xs in (x:ys, zs)

{-
ghci> my_break (<3) [1,2,3,4,5]
([],[1,2,3,4,5])
ghci> my_break (<2) [1,2,3,4]
([],[1,2,3,4])
-}

-- Implement the Prelude functions and, or, concat using foldr

my_and :: [Bool] -> Bool
my_and = foldr (&&) True

{-
ghci> my_and [True, False, True]
False
ghci> my_and [True, True, True]
True
-}

my_or :: [Bool] -> Bool
my_or = foldr (||) False

{-
ghci> my_or [False, False, True]
True
ghci> my_or [False, False, False]
False
-}

my_concat :: [[a]] -> [a]
my_concat = foldr (++) []

{-
ghci> my_concat [[1,2], [3,4], [5]]
[1,2,3,4,5]
-}

-- Implement the Prelude functions sum, product, reverse using foldl

my_sum :: Num a => [a] -> a
my_sum = foldl (+) 0

{-
ghci> my_sum [1,2,3]
6
ghci> my_sum [2,4,6,8,10]
30
-}

my_product :: Num a => [a] -> a
my_product = foldl (*) 1

{-
ghci> my_product [1,2,3]
6
ghci> my_product [2,4,6,8,10]
3840
-}

my_reverse :: [a] -> [a]
my_reverse = foldl (flip (:)) []

{-
ghci> my_reverse [1,2,3]
[3,2,1]
ghci> my_reverse [2,4,6,8,10]
[10,8,6,4,2]
-}

---- Part 4: Extra Credit ----------------

-- Convert a Tree into an equivalent Tree2, IF POSSIBLE. That is, given t1,
-- return t2 such that conv21 t2 = t1, if it exists. (In math, this is called
-- the "inverse image" of the function conv21.)  Thus, if conv21 t2 = t1, then
-- it should be that conv 12 t1 = Just t2. If there does not exist such a t2,
-- then conv12 t1 = Nothing. Do some examples on paper first so you can get a
-- sense of when this conversion is possible.
conv12 :: Tree a -> Maybe (Tree2 a)
conv12 Empty = Nothing
conv12 (Node x Empty Empty) = Just (Leaf x)
conv12 (Node x l r) = do
    l' <- conv12 l
    r' <- conv12 r
    return (Node2 x l' r')

{-
ghci> conv12 myTree
Nothing
-}

-- Binary Search Trees. Determine, by making only ONE PASS through a tree,
-- whether or not it's a Binary Search Tree, which means that for every
-- Node a t1 t2 in the tree, every element in t1 is strictly less than a and
-- every element in t2 is strictly greater than a. Complete this for both
-- Tree a and Tree2 a.

-- Hint: use a helper function that keeps track of the range of allowable
-- element values as you descend through the tree. For this, use the following
-- extended integers, which add negative and positvie infintiies to Int:

data ExtInt = NegInf | Fin Int | PosInf deriving Eq

instance Show ExtInt where
  show NegInf     = "-oo"
  show (Fin n) = show n
  show PosInf     = "+oo"

instance Ord ExtInt where
  compare NegInf  NegInf  = EQ
  compare NegInf  _       = LT
  compare (Fin n) (Fin m) = compare n m
  compare (Fin n) PosInf  = LT
  compare PosInf  PosInf  = EQ
  compare _       _       = GT
  -- Note: defining compare automatically defines <, <=, >, >=, ==, /=

bst :: Tree Int -> Bool
bst = is_bst NegInf PosInf
    where
    is_bst _ _ Empty = True
    is_bst lo hi (Node x l r) = (Fin x > lo) && (Fin x < hi) && is_bst lo (Fin x) l && is_bst (Fin x) hi r

{-
ghci> bst myTree
False
ghci> bst (Node 8 (Node 10 Empty Empty) Empty)
False
-}

bst2 :: Tree2 Int -> Bool
bst2 = is_bst NegInf PosInf
    where
    is_bst lo hi (Leaf x) = (Fin x > lo) && (Fin x < hi)
    is_bst lo hi (Node2 x l r) = (Fin x > lo) && (Fin x < hi) && is_bst lo (Fin x) l && is_bst (Fin x) hi r

{-
ghci> bst2 tree2
False
ghci> bst2 (Node2 8 (Leaf 2) (Node2 10 (Leaf 3) (Leaf 5)))
False
-}
