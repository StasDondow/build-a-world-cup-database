#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games;")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]]
  then
    # add values to Teams table
    IS_WINNER_IN_TABLE=$($PSQL "SELECT name FROM teams WHERE name = '$WINNER';")
    if [[ -z $IS_WINNER_IN_TABLE ]]
    then 
      echo $($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")
    fi

    IS_OPPONENT_IN_TABLE=$($PSQL "SELECT name FROM teams WHERE name = '$OPPONENT';")
    if [[ -z $IS_OPPONENT_IN_TABLE ]]
    then 
      echo $($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")
    fi

    # add values to Games table
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER';")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT';")
    echo $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);")
  fi
done 
