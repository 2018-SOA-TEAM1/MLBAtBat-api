# MLBAtBat Web API ![Build Status](https://travis-ci.org/ISS-SOA/codepraise-api.svg?branch=master)

Web API that allows MLB game information to be got and stored.

## Routes

### Root check

`GET /`

Status:

- 200: API server running (happy)

### Store game information
(Need to get resource from MLB API)
`POST /games/{game_date}/{team_name}`

Status
- 404: input game information is wrong (sad)
- 500: problems with MLB data api (bad)

### Get stored game information (game_info)
`GET /games/{game_date}/{team_name}`

Status
- 200: game returned (happy)
- 404: game not found in database (sad)
- 
### Get first game from db 
(when users haven't searched a game, we choose first game in db to present game information on Homepage)
`GET /games/first`

Status
- 200: wholegame returned (happy)
- 404: there's no game in database (sad)
- 
### Get all game_info from db 
`GET /games`

Status
- 200: list of game_info return (happy)
- 500: server error (sad)
