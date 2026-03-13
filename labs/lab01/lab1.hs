-- CSci 117, Lab 1:  Introduction to Haskell
-- Student Name: Noah Wiley
---------------- Part 1 ----------------

-- WORK through Chapters 1 - 3 of LYaH. Type in the examples and make
-- sure you understand the results.  Ask questions about anything you
-- don't understand! This is your chance to get off to a good start
-- understanding Haskell.


---------------- Part 2 ----------------

-- The Haskell Prelude has a lot of useful built-in functions related
-- to numbers and lists.  In Part 2 of this lab, you will catalog many
-- of these functions.

-- Below is the definition of a new Color type (also called an
-- "enumeration type").  You will be using this, when you can, in
-- experimenting with the functions and operators below.
data Color = Red | Orange | Yellow | Green | Blue | Violet
     deriving (Show, Eq, Ord, Enum)

-- For each of the Prelude functions listed below, give its type,
-- describe briefly in your own words what the function does, answer
-- any questions specified, and give several examples of its use,
-- including examples involving the Color type, if appropriate (note
-- that Color, by the deriving clause, is an Eq, Ord, and Enum type).
-- Include as many examples as necessary to illustration all of the
-- features of the function.  Put your answers inside {- -} comments.
-- I've done the first one for you (note that "λ: " is my ghci prompt).


-- succ, pred ----------------------------------------------------------------

{- 
succ :: Enum a => a -> a
pred :: Enum a => a -> a

For any Enum type, succ gives the next element of the type after the
given one, and pred gives the previous. Asking for the succ of the
last element of the type, or the pred of the first element of the type
results in an error.

λ: succ 5
6
λ: succ 'd'
'e'
λ: succ False
True
λ: succ True
*** Exception: Prelude.Enum.Bool.succ: bad argument
λ: succ Orange
Yellow
λ: succ Violet
*** Exception: succ{Color}: tried to take `succ' of last tag in enumeration
CallStack (from HasCallStack):
  error, called at lab1.hs:18:31 in main:Main
λ: pred 6
5
λ: pred 'e'
'd'
λ: pred True
False
λ: pred False
*** Exception: Prelude.Enum.Bool.pred: bad argument
λ: pred Orange
Red
λ: pred Red
*** Exception: pred{Color}: tried to take `pred' of first tag in enumeration
CallStack (from HasCallStack):
  error, called at lab1.hs:18:31 in main:Main
-}


-- toEnum, fromEnum, enumFrom, enumFromThen, enumFromTo, enumFromThenTo -------
-- As one of your examples, try  (toEnum 3) :: Color --------------------------

{-
The toEnum for enum types will return the element from that int position provided in the first argument. The toEnum will return the element that is found in that position

--enumFrom will take an Enum element as an argument, and it will repeat that element and also return the rest of the elements in ascending order of that list

enumFrom will return a list that starts from the argument passed followed by whatever other elements are in the list until it reaches the end of the list

enumFromthen for all enum types will return a list that I've noticed has a particular pattern to which elements it returns.
Based on the testing I did on the terminal, the elements in the list are based on the first argument times the position of where the second one is.

enumFromTo for all enum types will return a list that contains the first argument and continues to fill elements from the original list until it reaches the second argument. 

enumFromThenTo for all enum types will return a list of elements that contain the first argument, the second argument, and anything between the second and third argument in most cases. This wasn't the case with the last test I ran, but I can conclude it may have to do with the positioning of the second and third arguments.
-}

{-
ghci> (toEnum 3) :: Color
Green

ghci> fromEnum Yellow
2

ghci> enumFrom Yellow
[Yellow, Green, Blue, Violet]

ghci> enumFromThen Red Orange
[Red, Orange, Yellow, Green, Blue, Violet]
-}

{-
ghci> enumFromTehn Organe Blue
[Orange, Blue]

ghci> enumFromthen Red Orange
<interactive>:3:1: error:
    Variable not in scope: enumFromthen :: Color -> Color -> t
    Suggested fix:
      Perhaps use one of these:
        `enumFromThen' (imported from Prelude),
        `enumFromThenTo' (imported from Prelude)

ghci> enumFromThen Red Orange
[Red, Orange, Yellow, Green, Blue, Violet]

ghci> enumFromThen Orange Violet
[Orange,Violet]

ghci> enumFromThen Yellow Violet
[Yellow, Violet]

ghci> enumFromThen Yellow Green
[Yellow, Green, Blue, Violet]

ghci> enumFromThen Orange Yellow
[Orange, Yellow, Green, Blue, Violet]

ghci> enumFromThen Blue Violet
[Blue, Violet]

ghci> enumFromThen Green Blue
[Green, Blue, Violet]

ghci> enumFromThen Red Yellow
[Red, Yellow, Blue]

ghci> enumFromTo Yellow Violet
[Yellow, Green, Blue, Violet]

ghci> enumFromTo Red Violet
[Red, Orange, Yellow, Green, Blue, Violet]

ghci> enumFromTo Red Yellow
[Red, Orange, Yellow]

ghci> enumFromTo Red Orange
[Red, Orange]

ghci> enumFromThenTo Red Violet

<interactive>:16:1: error:
    * No instance for (Show (Color -> [Color]))
        arising from a use of `print'
        (maybe you haven't applied a function to enough arguments?)
    * In a stmt of an interactive GHCi command: print it
ghci> enumFromThenTo Red [Red..Violet]

<interactive>:17:21: error:
    Not in scope: `Red..'
    NB: no module named `Red' is imported.

<interactive>:17:21: error:
    A section must be enclosed in parentheses thus: (Red.. Violet)
ghci> enumFromThenTo Red

<interactive>:18:1: error:
    * No instance for (Show (Color -> Color -> [Color]))
        arising from a use of `print'
        (maybe you haven't applied a function to enough arguments?)
    * In a stmt of an interactive GHCi command: print it
ghci> :info enumFromThenTo
type Enum :: * -> Constraint
class Enum a where
  ...
  enumFromThenTo :: a -> a -> a -> [a]
        -- Defined in `GHC.Enum

ghci> enumFromThenTo Red Yellow Violet
[Red, Yellow, Blue]

ghci> enumFromThenTo Red Orange Yellow
[Red, Orange, Yellow]

ghci> enumFromThenTo Red Orange Blue
[Red, Orange, Yellow, Green, Blue]

ghci> enumFromThenTo Orange Green Blue
[Orange, Green]

-}
-- ==, /= ---------------------------------------------------------------------
{-
Both the == and the /= are of Eq type, and they return a boolean statement, either "True" or "False," depending on what kind of argument you are comparing. This operation works for Integer Values and float values, works for the Color Data set that was created above, and also works for lists. These operators will compare two arguments from the previous list and will return to the user either True or False. One thing to note for lists is that operators take order seriously, and a /= comparison will return false if we were to compare a list of [1,2,3] and [1,3,2] because the order matters even though they have the same elements

ghci 5==3
False
ghci> "abcd" == "abcd"
True
ghci> [10,11,12] == [10,11,12]
True
ghci> Red == 2

<interactive>:10:11: error:
    * No instance for (Num Color) arising from the literal `2'
    * In the second argument of `(==)', namely `2'
      In the expression: Yellow == 2
      In an equation for `it': it = Yellow == 2
ghci> 4/=10
True
ghci> 5/= 5
False
ghci> "Blue" /= "Red"
True
ghci> [1,2,3] /= [1,3,2]
True
ghci> Violet /= False

interactive>:15:11: error:
    * Couldn't match expected type `Color' with actual type `Bool'
    * In the second argument of `(/=)', namely `False'
      In the expression: Violet /= False
      In an equation for `it': it = Violet /= False
ghci>
-}


-- quot, div (Q: what is the difference? Hint: negative numbers) --------------

{-
Both the quot and div functions for all Integer types will be able to calculate the quotient of the first number divided by the second number. Attempting to give the quot or div function a float or a double type of value will result in an error. I couldn't find any particular difference between the two

ghci> quot (-40) (2)
-20
ghci> quot (-40) (-2)
20
ghci> div (-200) (20)
-10
ghci> div (-200) (-20)
10
ghci> div 20 -2

• No instance for (Show (Integer -> Integer))
        arising from a use of ‘print’
        (maybe you haven't applied a function to enough arguments?)
    • In a stmt of an interactive GHCi command: print it

ghci> div 45 6.4

<interactive>:12:1: error:
    • Ambiguous type variable ‘a0’ arising from a use of ‘print’
      prevents the constraint ‘(Show a0)’ from being solved.
      Probable fix: use a type annotation to specify what ‘a0’ should be.
      Potentially matching instances:
        instance Show Ordering -- Defined in ‘GHC.Show’
        instance Show a => Show (Maybe a) -- Defined in ‘GHC.Show’
        ...plus 25 others
        ...plus 14 instances involving out-of-scope types
        (use -fprint-potential-instances to see them all)
    • In a stmt of an interactive GHCi command: print it

-}


-- rem, mod  (Q: what is the difference? Hint: negative numbers) --------------

{-
mod and rem for all integer types returns the remainder after calculating the integer division of the 2 arguments
. Double or float point values won't work with this function, although the two work similarly. The difference lies when negative integers are brought as arguments. Rem will return certain values as negative when a mod function will return positive ints as seen in the second example.

ghci> mod (-40) (2)
0
ghci> mod (-32) (7)
3
ghci> mod 30 6
0
ghci> mod 37 8
5
ghci> mod 94 4
2

ghci> rem (-40) (2)
0
ghci> rem (-32) (7)
-4
ghci> rem 30 6
0
ghci> rem 37 8
5
ghci> rem 94 4
2
ghci> rem (-91) (-6)
-1
-}

-- quotRem, divMod ------------------------------------------------------------

{-
quotRem for all integers types returns a tuple with the first value in the tuple being the quotient that the first-second argument goes into the first. The second value in the tuple is the remainder of the quotient between the arguments.

divMod works very similar to quotRem with integer types and returning a tuple. However, there are some differences when you plug in negative numbers in example 4 of each, divMod returned -8 rather than -7

ghci> quotRem 3 4
(0,3)
ghci> quotRem 12 3
(4,0)
ghci> quotRem 15 6
(2,3)
ghci> quotRem (-30) (4)
(-7,-2)
ghci> quotRem (-11) (-2)
(-5,-1)

ghci> divMod 3 4
(0,3)
ghci> divMod 12 3
(4,0)
ghci> divMod 15 6
(2,3)
ghci> divMod (-30) (4) 
(-8,2)
ghci> divMod (-11) (-2)
(5,-1)

-}

-- &&, || ---------------------------------------------------------------------

{-
The && and || functions for all boolean types return a boolean, either true or false, depending on the comparison. The && works like an AND operation in logic where an argument is only true if both arguments are true, and the ||, on the other hand, acts like the OR operation in logic where only 1 of the arguments needs to be true

ghci> 5 && 5

<interactive>:16:1: error:
    * No instance for (Num Bool) arising from the literal `5'
    * In the first argument of `(&&)', namely `5'
      In the expression: 5 && 5
      In an equation for `it': it = 5 && 5
ghci> True && False
False
ghci> False && False
False
ghci> True||True
True
ghci> True||False
True
ghci> False||False
False

-}

-- ++ -------------------------------------------------------------------------

{-
The ++ operator for all list types combines two lists into one, and it can also combine serval strings into one as well. When trying to add a different color type, Burgandy, into the Color data type it wouldn't take the argument because it's not the same type

ghci> [1,2,3] ++ [4,5,6]
[1,2,3,4,5,6]
ghci> "CSCI" ++ "" ++ "117"
"CSCI117"
ghci> Color ++ [Burgandy]

<interactive>:36:1: error:
    * Illegal term-level use of the type constructor or class `Color'
    * defined at C:\Users\bmora\Downloads\lab1-1.hs:21:1
    * In the first argument of `(++)', namely `Color'
      In the expression: Color ++ [Burgandy]
      In an equation for `it': it = Color ++ [Burgandy]
-}

-- compare --------------------------------------------------------------------

{-
For all Ord types, the compare function returns either LT, GT, or EQ when comparing two arguments. From the tests I ran, if the string/integer/floating point values are equal, then the comparison will return EQ. However, when testing distinct values, I found that if left argument is less than the right argument, the compare will return LT. Likewise, if I were to switch the setup, if the right argument is less than the left argument then the compare will return GT 

ghci> compare 5 10
LT
ghci> compare 10 5
GT
ghci> compare 5 5
EQ
ghci> compare "Hi" "Hi"
EQ
ghci> compare 2.0 6.5
LT
compare 4.5 1.5
GT
-}

-- <, > -----------------------------------------------------------------------

{-
For all Ord types, the < and > operators will return a boolean, either True or False, when comparing two arguments. The less than and greater than works for numbers strings, and it worked with the Color data structure and was accurate based on what position the color was in the list.	

ghci> 11 < 20
True
ghci> Red < Green
True
ghci> 21 < 4
False

ghci> 11 > 20
False
ghci> Blue > Red
True
ghci> 2.0 > 1.0
True

-}

-- max, min -------------------------------------------------------------------

{-
The max function for all Ord types will return the greater value between the two arguments. For the min function, for all Ord types, the min function will return the smaller value out of the two arguments.

ghci> max 5 4
5
ghci> max 40.0 100.1
100.1
ghci> max Red Orange
Orange

ghci> min 7 30
7
ghci> min 32.1 74.3
32.1
ghci> min Blue Violet
Blue

-}

-- ^ --------------------------------------------------------------------------

{-
For all num types, the ^ operator works as an exponential function in math. The ^ operator will take two arguments but separate them with the ^. The format is pretty straightforward, with '6^2" translating to 6 raised to the power of 2

ghci> 6^2
36
ghci> 10^3
1000
ghci> 3.5^5
525.21875
ghci> (-2) ^ 5
-32

-}

-- concat ---------------------------------------------------------------------

{-

For foldable types the concat function will combine multiple lists into one big list. The concat work similar to the ++ operator

ghci> concat [[1,2], [3,4], [5,6]]
[1,2,3,4,5,6]
ghci> concat ["Hello", " ", "World"]
"Hello World"
ghci> concat [[Color], [Burgandy]]

<interactive>:71:10: error:
    * Illegal term-level use of the type constructor or class `Color'
    * defined at C:\Users\bmora\Downloads\lab1-1.hs:21:1
    * In the expression: Color
      In the expression: [Color]
      In the first argument of `concat', namely `[[Color], [Burgandy]]'
ghci> concat [[1.2, 3.4], [4.2, 5.4]]
[1.2,3.4,4.2,5.4]

-}

-- const ----------------------------------------------------------------------

{-
For all types, the const function will take in two arguments they could be numbers, strings, the color data type, and even booleans. Const will always return whatever the first argument is and you can mix and match different data types

ghci> const 12 4
12
ghci> const Yellow Blue
Yellow
ghci> const "EEE" "AAA"
"EEE"
ghci> const 4 "Four"
4
ghci> const True False
True
ghci> const False 3000
False

-}

-- cycle ----------------------------------------------------------------------

{-
For lists and enumerated types, the cycle function, as the name suggests, will cycle through a list, a series of characters, depending on how much the user gives in the "take x" line. Just typing cycle and giving a list, For example, it will result in an infinite loop of cycling through the same list.

ghci> cycle [1,2,3]
results in an infinite loop of 1,2,3

ghci> take 20 (cycle [1,2])
[1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2]
ghci> take 10 (cycle "hi")
"hihihihihi"

-}

-- drop, take -----------------------------------------------------------------

{-
The drop function for all Int types will take two arguments; the first argument determines the number of elements to take away from the second argument, which is the list.

ghci> drop 3 [1,2,3,4,5]
[4,5]
ghci> drop 2 [1,2,3,4]
[3,4]

ghci> take 3 [1,2,3,4,5,6,7,8]
[1,2,3]
ghci> take 5 [1,2,3,4,5,6,7,8,9,10]
[1,2,3,4,5]
ghci> take 0 [1,2,3,4,5]
[]

-}

-- elem -----------------------------------------------------------------------

{-
elem for Eq types acts as a search function to look for a specific element in a list or string. elem takes two arguments; the first one is the element you want to find and the second argument will take the list or string to look in

hci> elem 4 [2,4,6,8]
True
ghci> elem 'o' "Hello"
True
ghci> elem Red Color

<interactive>:100:10: error:
    * Illegal term-level use of the type constructor or class `Color'
    * defined at C:\Users\bmora\Downloads\lab1-1.hs:21:1
    * In the second argument of `elem', namely `Color'
      In the expression: elem Red Color
      In an equation for `it': it = elem Red Color
ghci> elem 3 [5,4,7,1,20]
False

-}

-- even -----------------------------------------------------------------------

{-
For all integer value types, even will return true if the int value is an even number and will return false if the value is odd. It does not work for float point values or the color data

ghci> even 2
True
ghci> even 5
False
ghci> even 6.0

<interactive>:14:1: error:
    • Ambiguous type variable ‘a0’ arising from a use of ‘even’
      prevents the constraint ‘(Integral a0)’ from being solved.
      Probable fix: use a type annotation to specify what ‘a0’ should be.
      Potentially matching instances:
        instance Integral Integer -- Defined in ‘GHC.Real’
        instance Integral Int -- Defined in ‘GHC.Real’
        ...plus one other
        ...plus one instance involving out-of-scope types
        (use -fprint-potential-instances to see them all)
    • In the expression: even 6.0
      In an equation for ‘it’: it = even 6.0

<interactive>:14:6: error:
    • Ambiguous type variable ‘a0’ arising from the literal ‘6.0’
      prevents the constraint ‘(Fractional a0)’ from being solved.
      Probable fix: use a type annotation to specify what ‘a0’ should be.
      Potentially matching instances:
        instance Fractional Double -- Defined in ‘GHC.Float’
        instance Fractional Float -- Defined in ‘GHC.Float’
        ...plus one instance involving out-of-scope types
        (use -fprint-potential-instances to see them all)
    • In the first argument of ‘even’, namely ‘6.0’
      In the expression: even 6.0
      In an equation for ‘it’: it = even 6.0

-}

-- fst ------------------------------------------------------------------------

{-
For any type, fst will return the 1st element in a tuple

ghci> fst (3,2)
3
ghci> fst (10,2)
10
ghci> fst ("AB", "BC")
"AB"

-}

-- gcd ------------------------------------------------------------------------

{-
For integral types, gcd will return the greatest common factor among the two arguments passed. This will only work for integer values and not for floating point values

ghci> gcd 100 40
20
ghci> gcd (-50) 10
10
ghci> gcd 6.0 4.0

<interactive>:20:1: error:
    • Ambiguous type variable ‘a0’ arising from a use of ‘print’
      prevents the constraint ‘(Show a0)’ from being solved.
      Probable fix: use a type annotation to specify what ‘a0’ should be.
      Potentially matching instances:
        instance Show Ordering -- Defined in ‘GHC.Show’
        instance Show a => Show (Maybe a) -- Defined in ‘GHC.Show’
        ...plus 25 others
        ...plus 14 instances involving out-of-scope types
        (use -fprint-potential-instances to see them all)
    • In a stmt of an interactive GHCi command: print it

-}

-- head -----------------------------------------------------------------------

{-
For any type head will return the first item of a list or first letter of a string

ghci> head [2,3,5,9]
2
ghci> head "CSCI117"
'C'
ghci> head Color

<interactive>:118:6: error:
    * Illegal term-level use of the type constructor or class `Color'
    * defined at C:\Users\bmora\Downloads\lab1-1.hs:21:1
    * In the first argument of `head', namely `Color'
      In the expression: head Color
      In an equation for `it': it = head Color

-}

-- id -------------------------------------------------------------------------

{- 
For all types, the id function seems to return exactly what the user type is. Since the name of this function is "id," I will assume this function just identifies the argument you give it.

ghci> id True
True
ghci> id 4
4
ghci> id 8.0
8.0
ghci> id "Red"
"Red"
ghci> id "Hello World?"
"Hello World?"

-}

-- init -----------------------------------------------------------------------

{-
The init function will remove the last element from any list or string and return the remaining list/string without the last element.

ghci> init [1,2,3,4,5,6,7]
[1,2,3,4,5,6]
ghci> init True

<interactive>:2:6: error:
    • Couldn't match expected type ‘[a]’ with actual type ‘Bool’
    • In the first argument of ‘init’, namely ‘True’
      In the expression: init True
      In an equation for ‘it’: it = init True
    • Relevant bindings include it :: [a] (bound at <interactive>:2:1)
ghci> init "CSCI 117"
"CSCI 11"

-}

-- last -----------------------------------------------------------------------

{- 
The last function will return the very last element from a list or return the very last character in a string 

ghci> last Color
<interactive>:131:6: error:
    * Illegal term-level use of the type constructor or class `Color'
    * defined at C:\Users\bmora\Downloads\lab1-1.hs:21:1
    * In the first argument of `last', namely `Color'
      In the expression: last Color
      In an equation for `it': it = last Color
ghci> :t last
last :: GHC.Stack.Types.HasCallStack => [a] -> a

ghci> last [1,2,3,4,5,6,7,8,9,10]
10
ghci> last "CSCI 117"
'7'

-}

-- lcm ------------------------------------------------------------------------
{-
For all Integral types, the lcm function will return the lowest value that both the arguments multiply into. It's like the opposite of the greatest common factor, where this function calculates the smallest common multiple of the two arguments.

ghci> lcm 30 4
60
ghci> lcm 2 8
8
ghci> lcm 5 10
10
ghci> lcm 40 2
40
ghci> lcm 100 45
900

-}

-- length ---------------------------------------------------------------------

{- 
For all foldable types, the length function will return the size of a list or string that is given into an argument

ghci> length "CSCI 117"
8
ghci> length [2,4,6,8,10,12,14,16,18,20]
10
ghci> length []
0

-}

-- null -----------------------------------------------------------------------

{-
The null function will return a boolean, either True or False, and evaluate if a list or string is empty or not. This didn't work with the Color data (or at least that I am aware of.

ghci> null []
True
ghci> null [1,2,3]
False
ghci> null "Empty?"
False
ghci> null ""
True
ghci> null Color
<interactive>:151:6: error:
    * Illegal term-level use of the type constructor or class `Color'
    * defined at C:\Users\bmora\Downloads\lab1-1.hs:21:1
    * In the first argument of `null', namely `Color'
      In the expression: null Color
      In an equation for `it': it = null Color
-}

-- odd ------------------------------------------------------------------------

{-
For int types, the odd function will determine whether an integer value is odd or not
The odd function will return a boolean, True or False, if the int is odd or not

ghci> odd 12
False
ghci> 
ghci> odd 15
True
ghci> odd 10
False
ghci> odd 15.0

<interactive>:22:1: error:
    • Ambiguous type variable ‘a0’ arising from a use of ‘odd’
      prevents the constraint ‘(Integral a0)’ from being solved.
      Probable fix: use a type annotation to specify what ‘a0’ should be.
      Potentially matching instances:
        instance Integral Integer -- Defined in ‘GHC.Real’
        instance Integral Int -- Defined in ‘GHC.Real’
        ...plus one other
        ...plus one instance involving out-of-scope types
        (use -fprint-potential-instances to see them all)
    • In the expression: odd 15.0
      In an equation for ‘it’: it = odd 15.0

<interactive>:22:5: error:
    • Ambiguous type variable ‘a0’ arising from the literal ‘15.0’
      prevents the constraint ‘(Fractional a0)’ from being solved.
      Probable fix: use a type annotation to specify what ‘a0’ should be.
      Potentially matching instances:
        instance Fractional Double -- Defined in ‘GHC.Float’
        instance Fractional Float -- Defined in ‘GHC.Float’
        ...plus one instance involving out-of-scope types
        (use -fprint-potential-instances to see them all)
    • In the first argument of ‘odd’, namely ‘15.0’
      In the expression: odd 15.0
      In an equation for ‘it’: it = odd 15.0
ghci> odd 23
True
ghci> odd 2
False

-}

-- repeat ---------------------------------------------------------------------

{-
For most types, the repeat function will create a list and fill it in with either a determined amount (if requested by the user) of the argument or if there are no parameters or limits set, then it will create an infinite size list of the argument.

ghci> take 10 (repeat (1,2))
[(1,2),(1,2),(1,2),(1,2),(1,2),(1,2),(1,2),(1,2),(1,2),(1,2)]
ghci> take 50 (repeat 10)
[10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10]
ghci> take 10 (repeat "CSCI 117")
["CSCI 117","CSCI 117","CSCI 117","CSCI 117","CSCI 117","CSCI 117","CSCI 117","CSCI 117","CSCI 117","CSCI 117"]

-}

-- replicate ------------------------------------------------------------------

{-
The replicate function acts similarly to the repeat function, but the format and argument format are different. The replicate will create a list of a given length of the second argument. If the second argument is a single char, then replicate will create one big string with the second argument.

ghci> replicate 4 10
[10,10,10,10]
ghci> replicate 10 "Hello"
["Hello","Hello","Hello","Hello","Hello","Hello","Hello","Hello","Hello","Hello"]
ghci> replicate 10 "CSCI 117"
["CSCI 117","CSCI 117","CSCI 117","CSCI 117","CSCI 117","CSCI 117","CSCI 117","CSCI 117","CSCI 117","CSCI 117"]

-}

-- reverse --------------------------------------------------------------------

{-
The reverse function will take a list or string and return it in reverse order from the original list or string

ghci> reverse "Fresno State"
"etatS onserF"
ghci> reverse [10,9,8,7,6,5,4,3,2,1]
[1,2,3,4,5,6,7,8,9,10]
ghci> reverse [10,20,30,40,50,60]
[60,50,40,30,20,10]

-}

-- snd ------------------------------------------------------------------------

{-
The snd function will return the second element in a tuple of any tuple type

ghci> snd (True, False)
False
ghci> snd (30,70)
70
ghci> snd ("ABC", "CBA")
"CBA"

-}

-- splitAt --------------------------------------------------------------------

{-
The split function can take a list or string as an argument and will split the argument

ghci> splitAt 4 [1,2,3,4,5,6,7,8]
([1,2,3,4],[5,6,7,8])
ghci> splitAt 3 ["One", "Two", "Three", "Four", "Five"]
(["One","Two","Three"],["Four","Five"])
ghci> splitAt Color
<interactive>:175:9: error:
    * Illegal term-level use of the type constructor or class `Color'
    * defined at C:\Users\bmora\Downloads\lab1-1.hs:21:1
    * In the first argument of `splitAt', namely `Color'
      In the expression: splitAt Color
      In an equation for `it': it = splitAt Color
ghci> splitAt 3 "Split?"
("Spl","it?")

-}

-- zip ------------------------------------------------------------------------

{-
The zip function will take two lists as arguments, and the end result is that it will create one big list that contains multiple tuples, with each tuple containing elements from both lists in the same position. This means that the tuples will start with a tuple of the first element from each list and then a tuple with the second, and so on.

ghci> zip [1,2,5,6] [3,5,10,30]
[(1,3),(2,5),(5,10),(6,30)]
ghci> zip [3, 8, 9] [10, 39, 91, 93, 100, 20]

-}

-- The rest of these are higher-order, i.e., they take functions as
-- arguments. This means that you'll need to "construct" functions to
-- provide as arguments if you want to test them.

-- all, any -------------------------------------------------------------------

{-
All functions for function types will return a boolean, either True or False, comparing a list to the function being performed. All functions passed in the first argument as True without needing all the elements to be True

ghci> all (<5) [1,3,4,5,9,19,20]
False
ghci> all (==2) [2,2,2]
True
ghci> all odd [1,3,5,7]
True

ghci> any (>5) [1,2,3,4]
False
ghci> any even [3,9,13,4,15]
True
ghci> any (==1) [3,14,1,50,43]
True

-}
-- break ----------------------------------------------------------------------

{-
The break function will return a tuple of two lists separated from the original list separated by the function/first argument condition for all function types and list types. The list will only be split once, even if the function/ first argument condition is met multiple times. If the condition isn't met, the original list is still separated, but nothing will be in the second list in the tuple.

ghci> break (=='S') "CSCI117"
("C","SCI117")
ghci> break (==0) [2,4,6,8]
([2,4,6,8],[])

-}

-- dropWhile, takeWhile -------------------------------------------------------

{-
dropWhile function types and lists will look at the condition to meet the first function in the first argument, and it will remove elements from the list until that condition is broken. Even if there are elements after that meet the condition, they won't be dropped once the function finds a component to stop it. 

takeWhile for function types and lists will create a list from the original and act similarly to the dropWhile function but instead of removing elements from the list,
takeWhile will add elements into the new list if it meet the condition from the first function argument and continue until the condition is broken. 

ghci> dropWhile (<3) [1,2,3,4,5,6]
[3,4,5,6]
ghci> dropWhile even [1,3,4,5,6,9,10]
[1,3,4,5,6,9,10]
ghci> dropWhile odd [1,3,4,16,7,9]
[4,16,7,9]

ghci> takeWhile (<5) [1,2,3,4,5,6,7,8]
[1,2,3,4]
ghci> takeWhile even [2,4,13,3,7,9]
[2,4]
ghci> takeWhile (>5) [1,3,5,7,9]
[]

-}

-- filter ---------------------------------------------------------------------

{-
For all function types and lists, will return a different list that contains all elements from the original list that meet the condition given by the first argument, will also return multiple of the same elements as seen in the last example.

ghci> filter odd [1,2,3,4,5,6,7,8,9,10]
[1,3,5,7,9]
ghci> filter (==5) [1,2,4,5,5,6,8,4,2,5,1,7,4,7,5]
[5,5,5,5]
ghci> filter (>5) [2,3,4,16,18,21,31]
[16,18,21,31]

-}

-- iterate --------------------------------------------------------------------

{-
For all function types, the iterate function as the name suggests will create a list where the first element is calculated by applying whatever function is provided in the second argument and the second element will be calculated by applying the function from the previous result and so forth.

ghci> take 10 (iterate (2+) 1)
[1,3,5,7,9,11,13,15,17,19]
ghci> take 20 (iterate (5*) 1)
[1,5,25,125,625,3125,15625,78125,390625,1953125,9765625,48828125,244140625,1220703125,6103515625,30517578125,152587890625,762939453125,3814697265625,19073486328125]

-}

-- map ------------------------------------------------------------------------

{-
For all function types, the map function will return a list that is made up of applying the function in the first argument in the first function to all the elements in the list. 

ghci> map abs [-1,-5,3,-15,10,15]
[1,5,3,15,10,15]
ghci> map (2*) [1,3,5,7]
[2,6,10,14]

-}

-- span -----------------------------------------------------------------------

{-
For all function types and lists, the span function will return a tuple that contains 2 lists
The first list contains elements starting from the first position, and it will keep adding elements to that first list until the condition in the first argument is broken. The second list will contain all the remaining elements after the condition is broken.

ghci> span (<3) [1,2.3,4,5,6,7,8,9,10]
([1.0,2.3],[4.0,5.0,6.0,7.0,8.0,9.0,10.0])
ghci> span (==5) [1,2,3,4,5,6,7,8,9,10]
([],[1,2,3,4,5,6,7,8,9,10])
ghci> span odd [1,2,3,4,5,6,7,8,9,10]
([1],[2,3,4,5,6,7,8,9,10])

-}
