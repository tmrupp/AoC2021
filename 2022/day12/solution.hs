import System.IO
import Data.List
import Data.Char ( ord )
import Debug.Trace
import Data.Maybe (fromJust)
import Data.Graph
import Data.IntMap.Merge.Lazy (preserveMissing)

getStart :: [[Int]] -> (Int, Int)
getStart area = _getVal area 0 (-14)
getEnd :: [[Int]] -> (Int, Int)
getEnd area = _getVal area 0 (-28)

_getVal :: [[Int]] -> Int -> Int -> (Int, Int)
_getVal area n val
    | x == Nothing = _getVal area (n + 1) val
    | otherwise = (n, fromJust x)
    where x = findIndex (== val) (area !! n)

distance h t = abs (fst h - fst t) + abs (snd h - snd t)

addPos a b = (fst a + fst b, snd a + snd b)

directions = [(0,1), (0,-1), (-1,0), (1,0)]

getHeight area x
    | x0 == -14 = 0
    | x0 == -28 = 25
    | otherwise = x0
    where x0 = area !! fst x !! snd x

isValid area x0 x1
    | fst x1 < 0 || fst x1 >= length area = False
    | snd x1 < 0 || snd x1 >= length (area !! fst x1) = False
    | otherwise = {-trace (show (getHeight area x0) ++ " " ++ show (getHeight area x1)) $-} diff <= 1
    where diff = (getHeight area x0) - (getHeight area x1)

getNeighbors :: (Ord a, Num a) => [[a]] -> (Int, Int) -> [(Int, Int)]
getNeighbors area x = filter (isValid area x) $ map (addPos x) directions

hVal :: ((Int, Int), Int) -> [(Int, Int)] -> Int
hVal x end = (snd x) + (minimum $ map (distance (fst x)) end)

updateHVal xs (new, h) = if n /= Nothing then take (fromJust n) xs ++ (new, h) : drop (fromJust n+1) xs else xs 
    where n =  findIndex (\x -> fst x == new && snd x > h) xs

addIfNotIn :: [((Int, Int), Int)] -> [((Int, Int), Int)] -> [((Int, Int), Int)]
addIfNotIn [] ys = ys
addIfNotIn (x:xs) ys = if fst x `elem` map fst ys then addIfNotIn xs (updateHVal ys x) else addIfNotIn xs (x:ys)

srch :: [[Int]] -> [(Int, Int)] -> [(Int, Int)] -> [((Int, Int), Int)] -> Int
srch area end prevs queue 
    | location `elem` end = trace ("yo n=" ++ show n) n
    | otherwise = trace ("end=" ++ show end ++ " checking=" ++ show location ++ " h=" ++ (show $ getHeight area location) ++ " depth=" ++ show n ++ " neighbors=" ++ show neighbors) $
                    srch area end (location:prevs) newQueue
    where   newQueue = sortBy (\a b -> compare (hVal a end) (hVal b end)) (addIfNotIn (map (, n+1) neighbors) (tail queue))
            neighbors = filter (`notElem` prevs) $ getNeighbors area location
            location = fst $ head queue
            n = snd $ head queue

getAllStarts [] _ = []
getAllStarts area n = (map (n,) $ findIndices (==0) (head area)) ++ getAllStarts (tail area) (n+1)

example xs end = sortBy (\a b -> compare (hVal a end) (hVal b end)) xs

part1 area = srch area ([getStart area]) [] [(getEnd area, 0)]

part2 area = srch area (getAllStarts area 0) [] [(getEnd area, 0)]

main = do
    handle <- openFile "day.in" ReadMode
    contents <- hGetContents handle
    
    let area = map (map (\x -> ord x - ord 'a') . filter (/= '\r')) $ lines contents
    print $ area
    print $ part1 area
    print $ part2 area
    let xs = [((0,0), 1),((100,99), 98),((50,50), 50),((34,2), 4)]
    let end = (100, 100)

    -- print $ "hey" ++ (show $ search area)
    -- print $ distance (22,1) (20, 136)
    -- print $ distance (23,0) (20, 136)
    -- print $ astar [(0,0),(0,1)] (0,1)

    hClose handle   