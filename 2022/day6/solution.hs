import System.IO
import Data.List

part1 :: Int -> Int -> String -> String -> Int
part1 marker i ys (x:xs)
    | length (nub ys) == marker = i
    | length ys == marker = part1 marker (i+1) (tail ys ++ [x]) xs
    | otherwise = part1 marker (i+1) (ys ++ [x]) xs

part2 = part1 14

main = do
    handle <- openFile "day.in" ReadMode
    contents <- hGetContents handle
    -- print $ f 0 0
    print $ part1 4 0 "" contents
    print $ part2 0 "" contents
    hClose handle   