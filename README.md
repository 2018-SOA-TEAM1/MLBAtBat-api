# Architecture (2018.11.11 update)
#### wholegame_mapper (root mapper)
- innings_mapper
- players_mapper
- gcms_mapper (game changing moments)
#### wholegame (root)
- innings -> inning -> plays
- players
- game-changing-mements


# MLBAtBat (2018.11.10 update)

Application that notifies you that your favorite player is at bat. Use it to keep following game when you are working! Besides, you can get game changing moments informariton and discuss with others on message board.

## Overview

MLBAtBat will pull data from MLB stats api and use it to notify you game changing moments when you can't keep watching game because you are working.  

Imagine you want to focus on working and follow MLB game at the same time. Although you can watch MLB gameday to get text information, it disturbs you a lot because you have to open a page or open your phone for several times. **MLBAtBat** will only notify you certain game changing moments that you want to follow.

You can also see game **schedule** on  **MLBAtBat**, and several **live game** data, including current hitter's name and score board.

## Short-term usability goals
- Pull data from MLB stats API, get live game information.
 
## Mid-term objectives 
- Send notification when interested hitter is going to be at bat.
- Record and show any game changing moments on board.
- Let multiple users discuss under game changing boards.

## Long-term goals
- Interact with users, enable them to set notification moments.
- Let users interact with each other, chatting under some special events.
