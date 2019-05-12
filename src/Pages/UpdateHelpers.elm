module Pages.UpdateHelpers exposing (individualSheetResponse, showRouteRequiringIndividualSheetApi)

import Dict exposing (Dict)
import Navigation exposing (newUrl)
import RemoteData exposing (WebData)

import Models.Model exposing (Model)
import Models.LeagueGames exposing (LeagueGames)
import Models.Config exposing (Config)
import Msg exposing (..)
import GoogleSheet.Api exposing (fetchIndividualSheet)
import Calculations.LeagueTableFromLeagueGames exposing (calculateLeagueTable)
import Calculations.ResultsFixturesFromLeagueGames exposing (calculateResultsFixtures)
import Routing exposing (toUrl)
import Models.Route as Route exposing (Route)

showRouteRequiringIndividualSheetApi : String -> Route -> Model -> ( Model, Cmd Msg )
showRouteRequiringIndividualSheetApi leagueTitle route model =
    ( { model | 
            leagueGames = RemoteData.Loading
            , resultsFixtures = RemoteData.Loading
            , leagueTables = Dict.insert leagueTitle RemoteData.Loading model.leagueTables
            , route = route 
      }
    , fetchLeagueGames leagueTitle model.config )


fetchLeagueGames : String -> Config -> Cmd Msg
fetchLeagueGames leagueTitle config =
    fetchIndividualSheet 
        leagueTitle
        config 
        (IndividualSheetResponse leagueTitle)

individualSheetResponse : Model -> WebData LeagueGames -> String -> ( Model, Cmd Msg )
individualSheetResponse  model response leagueTitle =
    ( 
        { model | 
            leagueGames = response
            , leagueTables = Dict.insert leagueTitle (RemoteData.map calculateLeagueTable response) model.leagueTables
            , resultsFixtures = RemoteData.map calculateResultsFixtures response }
        , newUrl <| toUrl <| model.route
    )
