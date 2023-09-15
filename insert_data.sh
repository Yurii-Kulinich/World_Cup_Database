#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

echo $($PSQL "TRUNCATE teams, games")

# Extract the unique countries from both "winner" and "opponent" columns
# cat games.csv | cut -d ',' -f 3,4 | tr ',' '\n' | sort -u | grep -v "winner" | grep -v "opponent" | sort

# Count the unique countries
# cat games.csv | cut -d ',' -f 3,4 | tr ',' '\n' | sort -u | grep -v "winner" | grep -v "opponent" | sort | wc -l

cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
if [[ $opponent != 'opponent' ]]
  then    
    #get team_id from table
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name ='$opponent'")
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name ='$winner'")
    #if not found
    if [[ -z $OPPONENT_ID ]]
    then
    #insert team into the table if not exists
    INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$opponent')")
    elif [[ -z $WINNER_ID ]]
    then 
    INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$winner')")
    fi
fi
done

cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
if [[ $opponent != 'opponent' ]]
  then    
    #get teams_id from table    
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name ='$opponent'")
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name ='$winner'")
    # insert the data into the table
    GAME_INSERT_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($year, '$round', $WINNER_ID, $OPPONENT_ID, $winner_goals, $opponent_goals)")
    echo "$GAME_INSER_RESULT"
fi
done

# Do not change code above this line. Use the PSQL variable above to query your database.
