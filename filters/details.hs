{-# LANGUAGE OverloadedStrings #-}
-- ^ this allows "string literals" to be type-inferred as, say, Text

-- details.hs
import Text.Pandoc.JSON
import System.Environment (getArgs)

details :: Maybe Format -> Block -> [Block]
details (Just (Format "html")) original@(Div (_id, classes, _attributes) (summary:rest))
  | "details" `elem` classes = [ detailOpen]
                            ++ [ summaryOpen, summary, summaryClose ] 
                            ++ rest
                            ++ [ detailClose ]
  | otherwise = [original]
    where [detailOpen, detailClose, 
           summaryOpen, summaryClose] = map (RawBlock "html") ["<details>", "</details>",
                                                               "<summary>", "</summary>"]
details _ original = [original]

main :: IO ()
main = toJSONFilter details
