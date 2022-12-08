import System.IO
import Data.List
import Data.Map (Map, insert, lookup, toList, empty, size, fromList, empty)
import Data.Map.Internal.Debug
import Data.Char
import Data.Maybe

import Debug.Trace

data FileSystem = FileSystem {
    dirs :: Map String ([String], Int),
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

into :: FileSystem -> String -> FileSystem
into fs dir = fs {hist=dir:hist fs}

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

defaultEntry :: Maybe ([a], Int) -> ([a], Int)
defaultEntry = fromMaybe ([], 0)

addToSize :: Maybe ([String], Int) -> Int -> ([String], Int)
addToSize xs x  = (fst (defaultEntry xs), snd (defaultEntry xs) + x)

-- addToDir :: String -> Int -> ([String], Int)
-- addToDir dir size = 

addFile :: FileSystem -> Int -> FileSystem
addFile fs size = fs {dirs=Data.Map.insert (top fs) (addToSize (Data.Map.lookup (top fs) (dirs fs)) size) (dirs fs)}

addToDirs :: Maybe ([String], Int) -> String -> ([String], Int)
addToDirs xs x  = (x : fst (defaultEntry xs), snd (defaultEntry xs))

addDir :: FileSystem -> String -> FileSystem
addDir fs dir = fs {dirs=Data.Map.insert (top fs) (addToDirs (Data.Map.lookup (top fs) (dirs fs)) dir) (dirs fs)}

ls fs
    | null $ cmds fs = fs
    | head (cmd fs) == "$" || null (cmds fs) = fs
    | all isDigit (head (cmd fs)) = ls $ addFile (exe fs) (read $ getSize fs)
    | otherwise = ls $ addDir (exe fs) (getCmd fs)


outputDirs :: [(String, ([String], Int))] -> String
outputDirs [] = ""
outputDirs (dir:dirs) = (fst dir) ++ ", "  ++ (concat (fst (snd dir))) ++ " : " ++ (Prelude.show $ snd (snd dir)) ++ (outputDirs dirs)

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

part2 xs = xs

main = do
    handle <- openFile "day.in" ReadMode
    contents <- hGetContents handle
    -- print $ f 0 0
    -- print $ Data.Map.toList $ dirs $ part1 (map words $ lines contents)
    -- print $ Data.Map.toList $ dirs FileSystem { dirs=Data.Map.fromList [("A", (["a", "b", "c"],1)),("B", (["a", "b", "c"],3)),("C", (["a", "b", "c"],2))] }
    let fs = execute $ newFileSystem (map words $ lines contents)
    print "part 1"
    print $ part1 fs
    -- print $ part2 contents
    hClose handle   