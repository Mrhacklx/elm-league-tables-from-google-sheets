module ResultsFixturesHelpers exposing (comparePosix, dateTimeInFebruary, expectDays, expectFirstDay, scheduledGame, unscheduledGame)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, intRange)
import Helpers exposing (vanillaDecodedGame)
import Models.DecodedGame exposing (DecodedGame)
import Models.LeagueGamesForDay exposing (LeagueGamesForDay)
import Models.ResultsFixtures exposing (ResultsFixtures)
import Time exposing (Month(..), Posix, posixToMillis, utc)
import Time.Extra exposing (Interval(..), Parts, add, partsToPosix)


comparePosix : Posix -> Posix -> Order
comparePosix date1 date2 =
    compare (posixToMillis date1) (posixToMillis date2)


expectDays : Int -> ResultsFixtures -> Expectation
expectDays expectedNumberOfDays resultsFixtures =
    Expect.equal expectedNumberOfDays (List.length resultsFixtures.days)


expectFirstDay : (Maybe LeagueGamesForDay -> Expectation) -> ResultsFixtures -> Expectation
expectFirstDay expect resultsFixtures =
    expect (List.head resultsFixtures.days)


unscheduledGame : DecodedGame
unscheduledGame =
    vanillaDecodedGame


scheduledGame : Posix -> DecodedGame
scheduledGame date =
    { vanillaDecodedGame | datePlayed = Just date }


dateTimeInFebruary : Fuzzer Posix
dateTimeInFebruary =
    Fuzz.map2
        (\days hours ->
            partsToPosix utc (Parts 2001 Feb 27 0 0 0 0)
                |> add Day days utc
                |> add Hour hours utc
        )
        (intRange 0 10)
        (intRange 0 23)
