import System.IO
import Data.List
import Data.Char
import Debug.Trace

expandCommand :: [String] -> [Int]
expandCommand (x:xs)
  | x == "addx" = 0 : [read (head xs) :: Int]
  | otherwise = [0]

-- signalStrength :: (Foldable t, Num [a]) => t [a] -> Int -> a
signal xs t = sum (take t xs) * t

kFold f i [] = []
kFold f i (x:xs) = p : kFold f p xs
  where p = f i x

part1 xs ts = sum $ map (signal xs) ts

draw :: Int -> Int -> String
draw x t = {- trace (show ct ++ " " ++ show x) -} ((if ct == 0 then "\n" else "") ++ (if x `elem` [ct-1, ct, ct+1] then "#" else ".") )
  where ct = t `mod` 40

part2 :: [Int] -> String
part2 xs = concat $ map (uncurry draw) $ zip xs [0..]

main = do
    handle <- openFile "day.in" ReadMode
    contents <- hGetContents handle
    print "hey"
    print $ (read "13" :: Int)
    print $ expandCommand ["addx", "13"]
    let cmds = 1:(concatMap (expandCommand . words) (lines contents))
    print $ cmds
    let cum = kFold (+) 0 cmds
    let times = [20, 60, 100, 140, 180, 220]
    -- print $ take 20 cmds
    print $ "cum=" ++ show (take 220 cum)
    print $ map (signal cmds) times
    print $ part1 cmds times
    putStrLn $ part2 cum

    hClose handle   