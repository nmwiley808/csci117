module Fraction (Fraction, frac) where

-- Fraction type. ADT maintains the INVARIANT that every fraction Frac n m
-- satisfies m > 0 and gcd n m == 1. For fractions satisfying this invariant
-- equality is the same as literal equality (hence "deriving Eq")

data Fraction = Frac Integer Integer deriving Eq


-- Public constructor: take two integers, n and m, and construct a fraction
-- representing n/m that satisfies the invariant, if possible (the case
-- where this is impossible is when m == 0).
frac :: Integer -> Integer -> Maybe Fraction
frac _ 0 = Nothing
frac n m = Just (normalize n m)

normalize :: Integer -> Integer -> Fraction
normalize n m = let g = gcd n m
                    n' = n `div` g
                    m' = abs (m `div` g)
                    in if m < 0 then Frac (-n') m' else Frac n' m'

{-
ghci> frac 3 4
Just 3/4
ghci> frac (-3) 4
Just -3/4
ghci> frac 4 8
Just 1/2
ghci> frac 5 0
Nothing
ghci> frac (-8) (-10)
Just 4/5
-}

-- Show instance that outputs Frac n m as n/m
instance Show Fraction where
    show (Frac n m)  = show n ++ "/" ++ show m

{-
ghci> show (Frac 1 2)
"1/2"
ghci> show (Frac (-1) 2)
"-1/2"
-}

-- Ord instance for Fraction
instance Ord Fraction where
    compare (Frac n1 m1) (Frac n2 m2) = compare (n1 * m2) (n2 * m1)

{-
ghci> Frac 1 2 < Frac 3 4
True
ghci> Frac 1 2 > Frac 4 5
False
-}

-- Num instance for Fraction
instance Num Fraction where
    (Frac n1 m1) + (Frac n2 m2) = normalize (n1 * m2 + n2 * m1) (m1 * m2)
    (Frac n1 m1) * (Frac n2 m2) = normalize (n1 *n2) (m1*m2)
    abs (Frac n m) = Frac (abs n) m
    signum (Frac n _) = Frac (signum n) 1
    fromInteger n = Frac n 1
    negate (Frac n m) = Frac (-n) m

{-
ghci> Frac 1 2 + Frac 1 3
5/6
ghci> Frac 1 2 + Frac 3 4
5/4
ghci> Frac 1 2 * Frac 3 4
3/8
ghci> Frac 2 5 * Frac 3 4
3/10
ghci> negate (Frac 1 2)
-1/2
ghci> negate (Frac 3 4)
-3/4
ghci> abs (Frac (-1) 2)
1/2
ghci> signum (Frac (-3) 4)
-1/1
ghci> signum (Frac 3 4)
1/1
ghci> singum (Frac 0 1)
ghci> fromInteger 4
4
ghci> fromInteger (-4)
-4
-}