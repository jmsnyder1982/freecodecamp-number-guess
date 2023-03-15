#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align --tuples-only -c"

SECRET_NUMBER=$(( $RANDOM % 1000 + 1 ))

CONTINUE=true
while $CONTINUE = true
do
echo -e "Enter your username:"
  read USERNAME
  LENGTH=`expr length "$USERNAME"`
  if [[ $LENGTH -le 22 ]]
  then
    CONTINUE=false
  else
    echo "Please enter a username that is 22 characters or less to proceed."
    CONTINUE=true
  fi
done

#check for username in database
USERNAME_ID=$($PSQL "SELECT username_id FROM username WHERE username = '$USERNAME'")

WIN=false
NUMBER_OF_GUESSES=0
#Username not found
if [[ -z $USERNAME_ID ]]
then
  INSERT_USERNAME=$($PSQL "INSERT INTO username(username) VALUES('$USERNAME')")
  USERNAME_ID=$($PSQL "SELECT username_id FROM username WHERE username = '$USERNAME'")
  echo -e "Welcome, $USERNAME! It looks like this is your first time here."
  echo -e "Guess the secret number between 1 and 1000:"
  read SECRET_NUMBER_GUESS
  while ! [[ "${SECRET_NUMBER_GUESS}" =~ ^[0-9]+$ ]]
  do
    echo -e "That is not an integer, guess again:"
    read SECRET_NUMBER_GUESS
  done
  let "NUMBER_OF_GUESSES+=1"
  while [ $WIN  == false ]
  do
    if [[ $SECRET_NUMBER_GUESS == $SECRET_NUMBER ]]
    then
      echo -e "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
      WINNER=$($PSQL "INSERT INTO guesses(username_id, number_of_guesses) VALUES($USERNAME_ID, $NUMBER_OF_GUESSES)")
      WIN=true
    elif [[ $SECRET_NUMBER_GUESS -lt $SECRET_NUMBER ]]
    then
      echo -e "It's higher than that, guess again:"
      read SECRET_NUMBER_GUESS
      while ! [[ "${SECRET_NUMBER_GUESS}" =~ ^[0-9]+$ ]]
      do
        echo -e "That is not an integer, guess again:"
        read SECRET_NUMBER_GUESS
      done
      let "NUMBER_OF_GUESSES+=1"
    else
      echo -e "It's lower than that, guess again:"
      read SECRET_NUMBER_GUESS
      while ! [[ "${SECRET_NUMBER_GUESS}" =~ ^[0-9]+$ ]]
      do
        echo -e "That is not an integer, guess again:"
        read SECRET_NUMBER_GUESS
      done
      let "NUMBER_OF_GUESSES+=1"
    fi
  done

#Username found
else
  GAMES_PLAYED=$($PSQL "SELECT COUNT(username_id) FROM guesses WHERE username_id=$USERNAME_ID")
  BEST_GAME=$($PSQL "SELECT MIN(number_of_guesses) FROM guesses WHERE username_id=$USERNAME_ID")
  echo -e "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  echo -e "Guess the secret number between 1 and 1000:"
  read SECRET_NUMBER_GUESS
  while ! [[ "${SECRET_NUMBER_GUESS}" =~ ^[0-9]+$ ]]
  do
    echo -e "That is not an integer, guess again:"
    read SECRET_NUMBER_GUESS
  done
  let "NUMBER_OF_GUESSES+=1"
  while [ $WIN  == false ]
  do
    if [[ $SECRET_NUMBER_GUESS == $SECRET_NUMBER ]]
    then
      echo -e "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
      WINNER=$($PSQL "INSERT INTO guesses(username_id, number_of_guesses) VALUES($USERNAME_ID, $NUMBER_OF_GUESSES)")
      WIN=true
    elif [[ $SECRET_NUMBER_GUESS -lt $SECRET_NUMBER ]]
    then
      echo -e "It's higher than that, guess again:"
      read SECRET_NUMBER_GUESS
      while ! [[ "${SECRET_NUMBER_GUESS}" =~ ^[0-9]+$ ]]
      do
        echo -e "That is not an integer, guess again:"
        read SECRET_NUMBER_GUESS
      done
      let "NUMBER_OF_GUESSES+=1"
    else
      echo -e "It's lower than that, guess again:"
      read SECRET_NUMBER_GUESS
      while ! [[ "${SECRET_NUMBER_GUESS}" =~ ^[0-9]+$ ]]
      do
        echo -e "That is not an integer, guess again:"
        read SECRET_NUMBER_GUESS
      done
      let "NUMBER_OF_GUESSES+=1"
    fi
  done
fi
