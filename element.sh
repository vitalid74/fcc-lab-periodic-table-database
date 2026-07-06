#!/bin/bash
PSQL_PATH="psql"
DB_USER="freecodecamp"
DB_NAME="periodic_table"
PSQL="$PSQL_PATH -U $DB_USER -d $DB_NAME -t -A -c"

if [ -z $1 ]
then
  # ./element.sh
  echo "Please provide an element as an argument."
else
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
  
  FIND_ELEMENT_RES=$($PSQL "$FIND_ELEMENT_REQ $FIND_ELEMENT_REQ_COND;")
  
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
  fi
fi
