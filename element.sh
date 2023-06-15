PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ $1 ]]
then

  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT_INFO=$($PSQL "SELECT * FROM elements WHERE atomic_number='$1'")
  else
    if [[ $1 =~ ^([A-Z]([a-z])?)$ ]]
    then
      ELEMENT_INFO=$($PSQL "SELECT * FROM elements WHERE symbol='$1'")
    else
      ELEMENT_INFO=$($PSQL "SELECT * FROM elements WHERE name='$1'")
    fi
  fi

  if [[ ! -z $ELEMENT_INFO ]]
  then
    echo $ELEMENT_INFO | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME
    do
      ELEMENT_PROPERTIES=$($PSQL "SELECT * FROM properties WHERE atomic_number='$ATOMIC_NUMBER';")
      echo $ELEMENT_PROPERTIES | while IFS="|" read ATOMIC_NUMBER ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE_ID
      do
        TYPE=$($PSQL "SELECT type FROM types WHERE type_id='$TYPE_ID';")
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
    done
  else
    echo I could not find that element in the database.
  fi

else
  echo Please provide an element as an argument.
fi
