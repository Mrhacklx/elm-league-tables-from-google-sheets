module Pages.ResultsFixtures.View exposing (page)

import Element exposing (..)
import Element.Attributes exposing (..)
import RemoteData exposing (WebData)
import Http exposing (decodeUri)

import Date exposing (..)
import Date.Extra exposing (..)
import Pages.Progressive exposing (..)
import LeagueStyleElements exposing (..)
import Msg exposing (..)
import Models.LeagueGamesForDay exposing (LeagueGamesForDay)
import Models.Game exposing (Game)
import Models.ResultsFixtures exposing (ResultsFixtures)
import Pages.MaybeResponse exposing (..)
import Pages.Page exposing (..)
import Pages.HeaderBar exposing (..) 
import Pages.HeaderBarItem exposing (..)


page : String -> WebData ResultsFixtures -> Progressive -> Page
page leagueTitle response progessive =
    Page
        ( DoubleHeader  
            (headerBar leagueTitle)
            (SubHeaderBar "Results / Fixtures"))
        ( maybeResponse response (fixturesResultsElement progessive) )

headerBar: String -> HeaderBar
headerBar leagueTitle = 
    HeaderBar 
        [ BackHeaderButton <| IndividualSheetRequest leagueTitle ] 
        (Maybe.withDefault "" (decodeUri leagueTitle))
        [ RefreshHeaderButton <| IndividualSheetRequestForResultsFixtures leagueTitle ]

fixturesResultsElement : Progressive -> ResultsFixtures -> Element Styles variation Msg
fixturesResultsElement progressive resultsFixtures =
    column 
        None 
        [ class "data-test-dates"
        , width <| percent 100
        , center 
        ]
        (List.map (day progressive) resultsFixtures.days)

day : Progressive -> LeagueGamesForDay -> Element Styles variation Msg
day progressive leagueGamesForDay =
    column 
        None 
        [ padding progressive.mediumGap
        , spacing progressive.mediumGap
        , dayWidth progressive
        , class <| "data-test-day data-test-date-" ++ (dateClassNamePart leagueGamesForDay.date)
        ]
        [ dayHeader leagueGamesForDay.date
        , dayResultsFixtures progressive leagueGamesForDay
        ] 

dayHeader : Maybe Date -> Element Styles variation Msg
dayHeader maybeDate =
    el 
        ResultFixtureDayHeader 
        [ class "data-test-dayHeader" ] 
        (text <| dateDisplay maybeDate)

dayResultsFixtures : Progressive -> LeagueGamesForDay -> Element Styles variation Msg
dayResultsFixtures progressive leagueGamesForDay =
    column 
        None 
        [ width <| percent 100
        , spacing progressive.smallGap
        ]
        (List.map (gameRow progressive) leagueGamesForDay.games)

gameRow : Progressive -> Game -> Element Styles variation Msg
gameRow progressive game =
    row 
        ResultFixtureRow 
        [ padding 0
        , spacing progressive.mediumGap
        , center
        , class "data-test-game"
        , width <| percent 100 ] 
        [ 
            paragraph 
                ResultFixtureHome 
                [ alignRight, teamWidth progressive, class "data-test-homeTeamName" ] 
                [ text game.homeTeamName ]
            , row 
                None 
                [ ] 
                ( scoreSlashTime game )
            , paragraph 
                ResultFixtureAway 
                [ alignLeft, teamWidth progressive, class "data-test-awayTeamName" ] 
                [ text game.awayTeamName ]
        ]

scoreSlashTime : Game -> List (Element Styles variation Msg)
scoreSlashTime game =
    case (game.homeTeamGoals, game.awayTeamGoals) of
        (Just homeTeamGoals, Just awayTeamGoals) ->
            [ 
                el 
                    ResultFixtureScore 
                    [ alignRight, class "data-test-homeTeamGoals" ] 
                    (text <| toString homeTeamGoals)
                , el 
                    ResultFixtureScore 
                    [ ] 
                    (text " - ")
                , el 
                    ResultFixtureScore 
                    [ alignLeft, class "data-test-awayTeamGoals" ] 
                    (text <| toString awayTeamGoals)
            ]
        (_, _) ->
            [ 
                el 
                    ResultFixtureTime 
                    [ verticalCenter, class "data-test-datePlayed" ] 
                    (text <| timeDisplay game.datePlayed)
            ]
            
dateClassNamePart: Maybe Date -> String
dateClassNamePart maybeDate = 
    maybeDate
    |> Maybe.map (Date.Extra.toFormattedString "yyyy-MM-dd") 
    |> Maybe.withDefault "unscheduled"

dateDisplay: Maybe Date -> String
dateDisplay maybeDate = 
    maybeDate
    |> Maybe.map (Date.Extra.toFormattedString "MMMM d, yyyy") 
    |> Maybe.withDefault "Unscheduled"

timeDisplay: Maybe Date -> String
timeDisplay maybeDate = 
    maybeDate
    |> Maybe.map (Date.Extra.toFormattedString "HH:mm")
    |> Maybe.withDefault " - "

dayWidth: Progressive -> Element.Attribute variation msg
dayWidth progressive = 
    if progressive.designTeamWidthMediumFont * 2.5 < progressive.viewportWidth * 0.8 then 
        width <| percent 80
    else 
        width <| percent 100
    
teamWidth: Progressive -> Element.Attribute variation msg
teamWidth progressive = 
    width <| fillPortion 50