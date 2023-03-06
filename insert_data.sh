#!/bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# delete all data from tables

echo "$($PSQL "truncate table games, teams;")"

# read file, check for comma & initiate variables YEAR, ROUND, WINNER, OPPONENT, WINNER_GOALS, OPPONENT_GOALS

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # as long as first year is different from 'year' continue to read
  if [[ $YEAR != year ]]
  then
  # check if winner exists in teams db: if yes, get id and add in games; if not - add new team, get id and insert in games
    WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    if [[ -z $WINNER_ID ]]
    then
      INSERT_WINNER=$($PSQL "insert into teams(name) values ('$WINNER')")
      WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    fi

  # check if opponent exists in teams db: if yes, get id and add in games; if not - add new team, get id and insert in games

    OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
    if [[ -z $OPPONENT_ID ]]
    then
      INSERT_OPPONENT=$($PSQL "insert into teams(name) values ('$OPPONENT')")
      OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
    fi
  # insert all data in games db
    INSERT_GAMES=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values ('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")
  fi
done