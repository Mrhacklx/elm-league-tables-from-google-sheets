module Models.Game exposing (Game, awayTeamGoals, homeTeamGoals, vanillaGame)

import Dict exposing (toList)
import Dict.Extra exposing (groupBy)
import Models.RealName as RealName exposing (hasRealName)
import Time exposing (Posix)



-- This type is what the google spreadsheet is decoded to, and is used
-- in results fixtures. It might be better to separate these two uses,
-- which would allow the minor smell of homeTeamGoalsWithRealPlayerNames
-- to be fixed


type alias Game =
    { homeTeamName : String

    -- homeTeamGoalCount and awayTeamGoalCount are considered necessary in the spreadsheet
    -- if they are not entered a game is considered invalid / not played yet
    , homeTeamGoalCount : Maybe Int
    , awayTeamName : String
    , awayTeamGoalCount : Maybe Int
    , datePlayed : Maybe Posix

    -- homeTeamGoalCount and awayTeamGoalCount are lists of goals (currently just a string
    -- that represents the name of the scorer). They are options. This creates
    -- the potential for a disconnect between the number of items in the list
    -- and the number of goals. I think this is Ok, we could add something to the
    -- docs later, but we don't control the data coming in so there isn't too much
    -- to do. We could do some logging / alerting / email when that functionality
    -- is availale
    , homeTeamGoals : List String
    , awayTeamGoals : List String
    , homeTeamCards : String
    , awayTeamCards : String
    , notes : String
    }


vanillaGame : Game
vanillaGame =
    Game "" Nothing "" Nothing Nothing [] [] "" "" ""


homeTeamGoals : Game -> List ( String, Int )
homeTeamGoals game =
    homeTeamGoalsWithRealPlayerNames game
        |> goalsAsPlayerOccurrences


awayTeamGoals : Game -> List ( String, Int )
awayTeamGoals game =
    awayTeamGoalsWithRealPlayerNames game
        |> goalsAsPlayerOccurrences


goalsAsPlayerOccurrences : List String -> List ( String, Int )
goalsAsPlayerOccurrences lst =
    Dict.Extra.groupBy identity lst
        |> Dict.toList
        |> List.map (\( playerName, occurrences ) -> ( playerName, List.length occurrences ))


homeTeamGoalsWithRealPlayerNames : Game -> List String
homeTeamGoalsWithRealPlayerNames game =
    List.filter RealName.hasRealName game.homeTeamGoals


awayTeamGoalsWithRealPlayerNames : Game -> List String
awayTeamGoalsWithRealPlayerNames game =
    List.filter RealName.hasRealName game.awayTeamGoals
