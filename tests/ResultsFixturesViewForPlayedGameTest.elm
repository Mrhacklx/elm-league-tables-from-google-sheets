module ResultsFixturesViewForPlayedGameTest exposing (onePlayedGame)

import Helpers exposing (vanillaGame)
import Msg exposing (Msg)
import ResultsFixturesViewHelpers exposing (html)
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector
import Time exposing (Month(..), utc)
import Time.Extra exposing (Parts, partsToPosix)


onePlayedGame : Test
onePlayedGame =
    describe "Displays date, teams and score for played games"
        [ test "date" <|
            \_ ->
                dayElement
                    |> Query.find [ Test.Html.Selector.class "data-test-dayHeader" ]
                    |> Query.has [ Test.Html.Selector.text "March 23rd, 2006" ]
        , test "homeTeamName" <|
            \_ ->
                dayElement
                    |> Query.find [ Test.Html.Selector.class "data-test-homeTeamName" ]
                    |> Query.has [ Test.Html.Selector.text "Castle" ]
        , test "homeTeamGoals" <|
            \_ ->
                dayElement
                    |> Query.find [ Test.Html.Selector.class "data-test-homeTeamGoals" ]
                    |> Query.has [ Test.Html.Selector.text "Cedd, Lisa, Barry" ]
        , test "homeTeamGoalCount" <|
            \_ ->
                dayElement
                    |> Query.find [ Test.Html.Selector.class "data-test-homeTeamGoalCount" ]
                    |> Query.has [ Test.Html.Selector.text "3" ]
        , test "awayTeamGoals" <|
            \_ ->
                dayElement
                    |> Query.find [ Test.Html.Selector.class "data-test-awayTeamGoals" ]
                    |> Query.has [ Test.Html.Selector.text "Chad, Pog" ]
        , test "awayTeamGoalCount" <|
            \_ ->
                dayElement
                    |> Query.find [ Test.Html.Selector.class "data-test-awayTeamGoalCount" ]
                    |> Query.has [ Test.Html.Selector.text "2" ]
        , test "awayTeamName" <|
            \_ ->
                dayElement
                    |> Query.find [ Test.Html.Selector.class "data-test-awayTeamName" ]
                    |> Query.has [ Test.Html.Selector.text "Meridian" ]
        ]


dayElement : Query.Single Msg
dayElement =
    html
        { vanillaGame
            | datePlayed = Just <| (Parts 2006 Mar 23 0 0 0 0 |> partsToPosix utc)
            , homeTeamName = "Castle"
            , homeTeamGoalCount = Just 3
            , homeTeamGoals = "Cedd, Lisa, Barry"
            , awayTeamName = "Meridian"
            , awayTeamGoals = "Chad, Pog"
            , awayTeamGoalCount = Just 2
        }
        |> Query.find [ Test.Html.Selector.class "data-test-day" ]
