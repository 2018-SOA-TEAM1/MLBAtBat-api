# MLBAtBat Web API ![Build Status](https://travis-ci.org/ISS-SOA/codepraise-api.svg?branch=master)

Web API that allowsGithub *projects* to be *appraised* for inidividual *contributions* by *members* of a team.

## Routes

### Root check

`GET /`

Status:

- 200: API server running (happy)

### Get a previously stored game
(Need to get resource from MLB API)
(Becuase we make a live api, the result would always change, so use POST not GET ?)
`POST /games/{game_date}/{team_name}`

Status

- 200: game returned (happy)
- 404: game not found (sad)
- 500: problems wuth MLB data api (bad)

### Store a particular game information

`POST /game_info/{game_date}/{team_name}`

Status

- 201: game_info stored (happy)
- 404: game not found (sad)
- 500: problems wuth MLB data api (bad)