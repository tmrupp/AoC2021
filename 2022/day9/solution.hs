import System.IO
import Data.List
import Data.Char
import Data.Bifoldable (bifind)

-- removes duplicates
rmdups :: (Ord a) => [a] -> [a]
rmdups = map head . group . sort

direction c
  | c == "U" = (0,1)
  | c == "D" = (0,-1)
  | c == "L" = (-1,0)
  | c == "R" = (1,0)

-- t (0,2)
-- _ (0,1)
-- h (0,0)

distance h t = (fst h - fst t, snd h - snd t) 

addPos a b = (fst a + fst b, snd a + snd b)

expandCommand c = replicate (read (c !! 1)) (head c)

moveHead h c = addPos h (direction c)

reduceDistance d
  | abs (fst d) > 1 || abs (snd d) > 1 = (signum(fst d), signum(snd d))
  | otherwise = (0, 0)

moveTail :: (Num a, Num b, Ord a, Ord b) => (a, b) -> (a, b) -> (a, b)
moveTail t h = addPos t (reduceDistance (distance h t))

kFold f i [] = []
kFold f i (x:xs) = p : kFold f p xs
  where p = f i x

part1 heads = length $ nub $ kFold moveTail (0, 0) heads

itr f x = x : itr f (f x)

tailDepth heads n = itr (kFold moveTail (0, 0)) heads !! n
part2 heads = length $ nub $ tailDepth heads 9

main = do
    handle <- openFile "day.in" ReadMode
    contents <- hGetContents handle
    -- print $ f 0 0
    -- let trees = map (map digitToInt . filter isDigit) (lines contents)
    let cmds = concatMap (expandCommand . words) (lines contents)
    let heads = kFold moveHead (0, 0) cmds
    -- print $ heads
    print $ part1 heads
    -- print $ tailDepth heads 9
    print $ part2 heads

    hClose handle   