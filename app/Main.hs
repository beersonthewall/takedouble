module Main where

import Data.List (sort)
import System.Environment (getArgs, getProgName)
import Takedouble (File (..), checkFullDuplicates, findPossibleDuplicates, getFileNames)
import Text.Printf (printf)

main :: IO ()
main = do
  args <- getArgs
  case args of
    [dir] ->
      do
        putStrLn $ "reading " <> dir
        filenames <- getFileNames dir
        putStrLn $ "comparing " <> show (length filenames) <> " files"
        likelyDups <- findPossibleDuplicates filenames -- each element in the list is a list of files that are likely duplicates
        let fnamesOnly = (filepath <$>) `fmap` likelyDups -- convert to a nested list of FilePath
        dups <- mapM checkFullDuplicates fnamesOnly
        mapM_ (\x -> putStr "\n" >> mapM_ putStrLn x) (sort $ concat dups)
    _ -> do
      name <- getProgName
      printf "Something went wrong - please use ./%s <dir>\n" name
