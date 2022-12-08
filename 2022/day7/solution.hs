import System.IO
import Data.List
import Data.Map (Map, insert, lookup, toList, empty, size, fromList, empty)
import Data.Map.Internal.Debug
import Data.Char
import Data.Maybe

import Debug.Trace

data FileSystem = FileSystem {
    dirs :: Map String ([String], Integer),
    hist :: [String],
    cmds :: [[String]]
} deriving (Show)

show :: FileSystem -> String
show fs = Data.Map.Internal.Debug.showTree (dirs fs)

newFileSystem xs = FileSystem {cmds=xs, dirs=Data.Map.empty, hist=[]}

out :: FileSystem -> FileSystem
out fs = fs {hist=tail $ hist fs}

up :: FileSystem -> FileSystem
up fs = fs {hist=["/"]}

path xs = foldl (\ a b -> a ++ "/" ++ b) "" xs

into :: FileSystem -> String -> FileSystem
into fs dir = fs {hist=(dir ++ path (hist fs)):hist fs}

cmd :: FileSystem -> [String]
cmd fs = head $ cmds fs
getCmd fs = cmd fs !! 1
getArg fs = cmd fs !! 2
getSize fs = cmd fs !! 0

exe fs = fs {cmds=tail $ cmds fs}

top fs = head $ hist fs

cd fs dir 
    | dir == ".." = out fs
    | dir == "/" = up fs
    | otherwise = into fs dir

defaultEntry :: Maybe ([a], Integer) -> ([a], Integer)
defaultEntry = fromMaybe ([], 0)

addToSize :: Maybe ([String], Integer) -> Integer -> ([String], Integer)
addToSize xs x  = (fst (defaultEntry xs), snd (defaultEntry xs) + x)

addFileToAll :: FileSystem -> Integer -> FileSystem
addFileToAll fs size = trace (Prelude.show (hist fs) ++ " size: " ++ Prelude.show size) foldl (addFile size) fs (hist fs) 

addFile :: Integer -> FileSystem -> String -> FileSystem
addFile size fs dir = fs {dirs=Data.Map.insert dir (addToSize (Data.Map.lookup dir (dirs fs)) size) (dirs fs)}

addToDirs :: Maybe ([String], Integer) -> String -> ([String], Integer)
addToDirs xs x  = (x : fst (defaultEntry xs), snd (defaultEntry xs))

addDir :: FileSystem -> String -> FileSystem
addDir fs dir = fs {dirs=Data.Map.insert (top fs) (addToDirs (Data.Map.lookup (top fs) (dirs fs)) dir) (dirs fs)}

ls fs
    | null $ cmds fs = fs
    | head (cmd fs) == "$" || null (cmds fs) = fs
    | all isDigit (head (cmd fs)) = ls $ addFileToAll (exe fs) (read $ getSize fs) 
    | otherwise = ls $ addDir (exe fs) (getCmd fs)


outputDirs :: [(String, ([String], Integer))] -> String
outputDirs [] = ""
outputDirs (dir:dirs) = (fst dir) ++ ", "  ++ (foldl (\a b -> a ++ " " ++ b) "" (fst (snd dir))) ++ " : " ++ (Prelude.show $ snd (snd dir)) ++ "\n" ++ (outputDirs dirs)

output fs = Prelude.show (hist fs) ++ " cmds=" ++ Prelude.show (cmds fs) ++ " size of dict=" ++ (Prelude.show $ Data.Map.size (dirs fs)) ++ " dict=" ++ Prelude.show (outputDirs $ Data.Map.toList (dirs fs))

execute fs
    | null (cmds fs) = fs
    | getCmd fs == "cd" = execute (cd (exe fs) (getArg fs)) 
    | getCmd fs == "ls" = execute (ls (exe fs)) 
    | otherwise = fs

-- addToTotalSize :: ([String], Int) -> Int -> ([String], Int)
-- addToTotalSize dir size = (fst dir, snd dir + size)

-- getTotalSize :: Map String ([String], Int) -> String -> [Int]
-- getTotalSize dirs dir  
--     | null $ fst entry = [snd entry]
--     | otherwise = snd entry + 
--     where entry = defaultEntry (Data.Map.lookup dir dirs)

part1 fs = sum $ filter (< 100000) (map (snd . snd) (Data.Map.toList (dirs fs)))


gettRootSize :: FileSystem -> Integer
gettRootSize fs = snd (defaultEntry (Data.Map.lookup "/" (dirs fs)))
part2 :: FileSystem -> Integer
part2 fs = foldl min (gettRootSize fs) $ filter (>= (gettRootSize fs - 40000000)) (map (snd . snd) (Data.Map.toList (dirs fs)))

-- 1036344 too low

main = do
    handle <- openFile "day.in" ReadMode
    contents <- hGetContents handle
    -- print $ f 0 0
    -- print $ Data.Map.toList $ dirs $ part1 (map words $ lines contents)
    -- print $ Data.Map.toList $ dirs FileSystem { dirs=Data.Map.fromList [("A", (["a", "b", "c"],1)),("B", (["a", "b", "c"],3)),("C", (["a", "b", "c"],2))] }
    let fs = execute $ newFileSystem (map words $ lines contents)
    print "part 1"
    putStrLn $ outputDirs (Data.Map.toList (dirs fs))
    print $ filter (> (70000000 - gettRootSize fs)) (map (snd . snd) (Data.Map.toList (dirs fs)))
    print $ gettRootSize fs
    print $ part1 fs
    print $ part2 fs
    hClose handle   