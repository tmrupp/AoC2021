import System.IO
import Data.List
import Data.Char
import Debug.Trace
import Data.Text (replace)

data Monkey = Monkey {
  items :: [Int], -- my items
  op :: Int -> Int, -- what op do I do?
  check :: Int -> Int, -- check which monkey to throw to
  count :: Int
}

instance Show Monkey where
    show x = show (count x) ++ ": " ++ show (items x)

parseItems :: String -> [Int]
parseItems xs = map read $ drop 2 $ words $ [x | x <- xs, x /= ',']

parseOp :: String -> (Int -> Int)
parseOp xs = \x -> op x (if xss !! 5 == "old" then x else read (xss !! 5)) `div` 3
  where (xss, op) = (words xs, if xss !! 4 == "+" then (+) else (*))

getFrom xs line word = read $ words (xs !! line) !! word

parseCheck :: [String] -> (Int -> Int)
parseCheck xs x
  = if x `mod` getFrom xs 0 3 == 0 then
        getFrom xs 1 5
    else
        getFrom xs 2 5

parseMonkey xs = trace (show $ length $ drop 3 xs) Monkey {count = 0, items = parseItems (xs !! 1), op = parseOp (xs !! 2), check = parseCheck (drop 3 xs)}

makeMonkeys :: [String] -> [Monkey]
makeMonkeys xs
  | length xs >= 7 = parseMonkey (take 6 xs) : makeMonkeys (drop 7 xs)
  | otherwise = [parseMonkey (take 6 xs)]

-- pullTop ms origin 
change :: [Monkey] -> Int -> Monkey -> [Monkey]
change ms n new = take n ms ++ new : drop (n+1) ms

popMonkey :: [Monkey] -> Int -> [Monkey]
popMonkey ms n = change ms n m {items=tail $ items m, count = count m + 1}
  where m = ms !! n

pushMonkey :: [Monkey] -> Int -> Int -> [Monkey]
pushMonkey ms n i = change ms n m {items = items m ++ [i]}
  where m = ms !! n

getItem ms n = op m (head $ items m)
  where m = ms !! n

getTarget ms n i = check m i
  where m = ms !! n

executeMonkey ms n = pushMonkey (popMonkey ms n) target item
  where (origin, item, target) = (ms !! n, getItem ms n, getTarget ms n item)

monkeyRound :: [Monkey] -> Int -> [Monkey]
monkeyRound ms n 
  | length ms == n = ms
  | null (items (ms !! n)) = monkeyRound ms (n + 1)
  | otherwise = monkeyRound (executeMonkey ms n) n

-- monkeyRounds ms n = monkeyRounds ms 0 n
monkeyRounds ms n
  | n == 0 = ms
  | otherwise = monkeyRounds (monkeyRound ms 0) (n - 1)

getHighest :: [Monkey] -> Int -> [Monkey]
getHighest ms n = take n $ sortBy (\a b -> compare (count b) (count a)) ms

part1 monkeys = product $ map (count) $ getHighest (monkeyRounds monkeys 20) 2

main = do
    handle <- openFile "day.in" ReadMode
    contents <- hGetContents handle
    -- print $ parseItems " Starting items: 54, 65, 75, 74"
    let monkeys = makeMonkeys (lines contents)
    print $ monkeys
    print $ monkeyRound monkeys 0
    print $ monkeyRounds monkeys 20
    print $ part1 monkeys

    hClose handle   