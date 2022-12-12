import System.IO
import Data.List
import Data.Char
import Data.Bifoldable (bifind)
import Control.Monad.RWS (All(getAll))

getHeight :: [[Int]] -> (Int, Int) -> Int
getHeight trees pos = trees !! fst pos !! snd pos

isHere bounds pos
    | low == fst pos || low == snd pos = True
    | (len-1) == fst pos || (wid-1) == snd pos = True
    | otherwise = False
    where (low, (len, wid)) = bounds

isEdge :: [[Int]] -> (Int, Int) -> Bool
isEdge trees = isHere (0, getDimensions trees)

addPos a b = (fst a + fst b, snd a + snd b)

isValid :: [[Int]] -> (Int, Int) -> Bool
isValid trees pos = not (isHere (0, getDimensions trees) pos)

getDimensions trees = (length trees, length (head trees))

takeWhileInclusive :: (t -> Bool) -> [t] -> [t]
takeWhileInclusive p [] = []
takeWhileInclusive p (x:xs) = x : if p x then takeWhileInclusive p xs
                                         else []

getColinear :: (Int, Int) -> [[Int]] -> (Int, Int) -> [(Int, Int)]
getColinear pos trees direction = drop 1 $ takeWhileInclusive (isValid trees) (iterate (addPos direction) pos)

checkDirection :: (Int, Int) -> [[Int]] -> (Int, Int) -> Bool
checkDirection pos trees direction = all
  ((< getHeight trees pos) . getHeight trees) $ getColinear pos trees direction

getViewingScore :: (Int, Int) -> [[Int]] -> (Int, Int) -> Int
getViewingScore pos trees direction = length $ takeWhileInclusive (< getHeight trees pos) $ map (getHeight trees) (getColinear pos trees direction)

isVisible :: [[Int]] -> (Int, Int) ->  Bool
isVisible trees pos 
    | isEdge trees pos = True
    | otherwise = any
  ((== True) . checkDirection pos trees)
  [(0, 1), (1, 0), (0, - 1), (- 1, 0)]

getAllViewingScores :: [[Int]] -> (Int, Int) ->  Int
getAllViewingScores trees pos =
  product $ map (getViewingScore pos trees)
  [(0, 1), (1, 0), (0, - 1), (- 1, 0)]

test :: [[Int]] -> Int
test xs = head (head xs)

part1 :: [[Int]] -> Int
part1 trees = length $ filter (==True) $ map (isVisible trees) ((,) <$> [0..len-1] <*> [0..wid-1])
    where (len, wid) = getDimensions trees

part2 :: [[Int]] -> Int
part2 trees = maximum $ map (getAllViewingScores trees) ((,) <$> [0..len-1] <*> [0..wid-1])
    where (len, wid) = getDimensions trees

main = do
    handle <- openFile "day.in" ReadMode
    contents <- hGetContents handle
    -- print $ f 0 0
    let trees = map (map digitToInt . filter isDigit) (lines contents)
    print $ part1 trees
    print $ part2 trees
    hClose handle   