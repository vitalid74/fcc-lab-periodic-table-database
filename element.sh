#!/bin/bash
PSQL_PATH="/usr/lib/postgresql/12/bin/psql"
PSQL_PATH="psql"
DB_USER="freecodecamp"
DB_NAME="periodic_table"
PSQL="$PSQL_PATH --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [ -z $1 ]
then
  # ./element.sh
  echo "Please provide an element as an argument."
else
  # ./element.sh 1
  # ./element.sh H
  # ./element.sh Hydrogen

  # RESULTS=$(psql -U $DB_USER -d $DB_NAME -t -A -F"," -c "SELECT * FROM elements;")
  # echo $RESULTS
  FIND_ELEMENT_REQ="SELECT * FROM elements e LEFT JOIN properties USING (atomic_number) LEFT JOIN types USING (type_id)"
  if [[ $1 =~ [0-9]+ ]]
  then 
    # ./element.sh 1
     FIND_ELEMENT_REQ_COND="WHERE $1 = e.atomic_number"
  else
    # ./element.sh H
    # ./element.sh Hydrogen
    FIND_ELEMENT_REQ_COND="WHERE '$1' = e.symbol OR '$1' = e.name"
  fi
  # FIND_ELEMENT_REQ="SELECT * FROM elements e LEFT JOIN properties USING (atomic_number) LEFT JOIN types USING (type_id) WHERE $1 = e.atomic_number OR '$1' = e.symbol OR '$1' = e.name;"

  # echo -e "Request:\n$PSQL \"$FIND_ELEMENT_REQ $FIND_ELEMENT_REQ_COND;\"\n"

  FIND_ELEMENT_RES=$($PSQL "$FIND_ELEMENT_REQ $FIND_ELEMENT_REQ_COND;")
      
  # echo -e "Result:\n$FIND_ELEMENT_RES"

  if [ -z $FIND_ELEMENT_RES ]
  then
    # ./element.sh (not in atomic_number, symbol, name)
    echo "I could not find that element in the database."
  else
     echo "$FIND_ELEMENT_RES" | while IFS='|' read -r TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELT BOIL TYPE 
      # IFS="," read -r name major
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
  done
  
    # echo "$ATOMIC_NUMBER, $SYMBOL, $NAME, $TYPE, $ATOMIC_MASS, $MELT, $BOIL"

    # echo "The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -250.1 celsius and a boiling point of -252.9 celsius."
  fi
fi#!/bin/bash
PSQL_PATH="/usr/lib/postgresql/12/bin/psql"
PSQL_PATH="psql"
PSQL="$PSQL_PATH --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [ -z $1 ]
then
  # ./element.sh
  echo "Please provide an element as an argument"
else
  if [ -n $1 ]
  then
    # ./element.sh 1
    # ./element.sh H
    # ./element.sh Hydrogen

    FIND_ELEMENT_REQ="SELECT * FROM elements e LEFT JOIN properties USING (atomic_number) WHERE $1 = e.atomic_number OR '$1' = e.symbol OR '$1' = e.name;"

    # FIND_ELEMENT_REQ="SELECT * FROM elements e LEFT JOIN properties USING (atomic_number) LEFT JOIN types USING (type_id) WHERE $1 = e.atomic_number OR '$1' = e.symbol OR '$1' = e.name;"

    echo "Request:"
    echo "$PSQL \"$FIND_ELEMENT_REQ\""

    FIND_ELEMENT_RES=$("$PSQL \"$FIND_ELEMENT_REQ\"")
    
    # FIND_ELEMENT_RES=$("$PSQL \"SELECT * FROM elements WHERE atomic_number = $1;\"")
    
    echo -e "Result:\n$FIND_ELEMENT_RES"

    if [ -z $FIND_ELEMENT_RES ]
    then
      IFS='|' read ATOMIC_NUMBER, SYMBOL, NAME, TYPE, ATOMIC_MASS, MELT, BOIL,  | echo $FIND_ELEMENT_RES

      echo "$ATOMIC_NUMBER, $SYMBOL, $NAME, $TYPE, $ATOMIC_MASS, $MELT, $BOIL"

      # echo "The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -250.1 celsius and a boiling point of -252.9 celsius."
    else
      # ./element.sh (not in atomic_number, symbol, name)
      echo "I could not find that element in the database."
    fi
  fi
fi
