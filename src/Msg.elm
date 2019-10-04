module Msg exposing (..)

import Models.LeagueGames exposing (LeagueGames)
import Models.LeagueSummary exposing (LeagueSummary)
import Navigation exposing (Location)
import RemoteData exposing (WebData)
import Window exposing (size)


type Msg
    = -- league List
      ShowLeagueList
    | RefreshLeagueList
    | AllSheetSummaryResponse (WebData (List LeagueSummary))
      -- Fixtures / Results, LeagueTable, TopScorers
    | ShowLeagueTable String
    | RefreshLeagueTable String
    | ShowResultsFixtures String
    | RefreshResultsFixtures String
    | ShowTopScorers String
    | RefreshTopScorers String
    | IndividualSheetResponse String (WebData LeagueGames)
      -- routing
    | OnLocationChange Location
      -- responsiveness
    | SetScreenSize Window.Size
      --
    | NoOp
