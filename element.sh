#!/bin/bash

CALL_ARGUMENT=$1
PSQL="psql --username=<user> --dbname=periodic_table -t --no-align -c"

# Arguments
# $1 can be a whole number, single letter, or one word
# If it is a number, it represents a properties.atomic number
# If it is a single letter, it represents an elements.symbol
# If it is a single world, it represents an elements.name

function GET_ELEMENT_BY_ATOMIC_NUMBER () {
  # $1 is a whole number
  # echo "I'm a number!"
  local QUERY=$($PSQL "
    SELECT atomic_number, symbol, name, type_id, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements
    LEFT JOIN properties USING(atomic_number) 
    LEFT JOIN types USING(type_id) 
    WHERE atomic_number=$1")
  PRINT_ELEMENT_WITH_PROPERTIES "${QUERY}"
}

function GET_ELEMENT_BY_NAME () {
  # $1 is one word
  # echo "I'm a word!"
  local QUERY=$($PSQL "
    SELECT atomic_number, symbol, name, type_id, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements   
    LEFT JOIN properties USING(atomic_number) 
    LEFT JOIN types USING(type_id) 
    WHERE name ILIKE '$1'
  ")
  PRINT_ELEMENT_WITH_PROPERTIES "${QUERY}"
}

function GET_ELEMENT_BY_SYMBOL () {
  # $1 is a 1-2 letters
  # echo "I'm a symbol!"
  local QUERY=$($PSQL "
    SELECT atomic_number, symbol, name, type_id, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements   
    LEFT JOIN properties USING(atomic_number) 
    LEFT JOIN types USING(type_id) 
    WHERE symbol ILIKE '$1'
  ")
  PRINT_ELEMENT_WITH_PROPERTIES "${QUERY}"
}

# NEVER CALL WITHOUT $1
function GET_ELEMENT_WITH_PROPERTIES () {
  # $1 could be a whole number, single letter, or one word

  if [[ $1 =~ ^[0-9]+$ ]]
  then
    GET_ELEMENT_BY_ATOMIC_NUMBER $1
  elif [[ ${#1} > 2 ]]
  then
    GET_ELEMENT_BY_NAME $1
  elif [[ ${#1} -ge 0 ]] && [[ ${#1} -le 2 ]] 
  then
    GET_ELEMENT_BY_SYMBOL $1
  fi
}

function PRINT_ELEMENT_WITH_PROPERTIES () {
  # $1 is the query result
  if [[ -z $1 ]]
  then
    echo "I could not find that element in the database."
  else
    IFS="|"
    read -ra PROPERTIES <<< ${1%%\|}
    
    ATOMIC_NUMBER=${PROPERTIES[0]}
    SYMBOL=${PROPERTIES[1]}
    NAME=${PROPERTIES[2]}
    TYPE=${PROPERTIES[4]}
    MASS=${PROPERTIES[5]}
    MELTING_POINT=${PROPERTIES[6]}
    BOILING_POINT=${PROPERTIES[7]}
    
    echo -e "The element with atomic number $ATOMIC_NUMBER is ${NAME^} (${SYMBOL^}). It's a $TYPE, with a mass of $MASS amu. ${NAME^} has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
}

if [[ $CALL_ARGUMENT == '' ]]
then
  echo "Please provide an element as an argument."
else  
  GET_ELEMENT_WITH_PROPERTIES $CALL_ARGUMENT
fi
