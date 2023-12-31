module CalculateFixturesResultsFromLeagueGamesTest exposing (GamesForDay, groupsGamesByDay)

import Calculations.ResultsFixturesFromLeagueGames exposing (calculateResultsFixtures)
import Expect exposing (Expectation)
import Fuzz exposing (list)
import List.Extra exposing (gatherWith)
import Models.DecodedGame exposing (DecodedGame)
import Models.LeagueGames exposing (LeagueGames)
import Models.ResultsFixtures exposing (ResultsFixtures)
import ResultsFixturesHelpers exposing (comparePosix, dateTimeInFebruary, scheduledGame)
import Test exposing (Test, fuzz)
import Time exposing (Posix, utc)
import Time.Extra exposing (Interval(..))


groupsGamesByDay : Test
groupsGamesByDay =
    fuzz (list dateTimeInFebruary) "Groups all scheduled games into a LeagueGamesForDay for each day" <|
        \dateTimes ->
            let
                games : List DecodedGame
                games =
                    List.map scheduledGame dateTimes

                groupedDates : List ( Posix, List Posix )
                groupedDates =
                    List.map (Time.Extra.floor Day utc) dateTimes
                        |> List.sortWith comparePosix
                        |> List.reverse
                        |> gatherWith (==)
            in
            calculateResultsFixtures (LeagueGames "Any League Title" games)
                |> expectNumberOfGamesForDates
                    (List.map
                        (\( firstDate, remainingDates ) ->
                            GamesForDay (Just firstDate) (1 + List.length remainingDates)
                        )
                        groupedDates
                    )


type alias GamesForDay =
    { date : Maybe Posix
    , numberOfGames : Int
    }


expectNumberOfGamesForDates : List GamesForDay -> ResultsFixtures -> Expectation
expectNumberOfGamesForDates expectedNumberOfDaysFordateTimes resultsFixtures =
    let
        actualNumberOfDaysFordateTimes : List GamesForDay
        actualNumberOfDaysFordateTimes =
            List.map (\leagueGamesForDay -> GamesForDay leagueGamesForDay.date (List.length leagueGamesForDay.games)) resultsFixtures.days
    in
    Expect.equalLists expectedNumberOfDaysFordateTimes actualNumberOfDaysFordateTimes
