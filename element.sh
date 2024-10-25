#!/bin/bash

CALL_ARGUMENT=$1
PSQL="psql --username=freecodecamp --dbname=<database_name> -t --no-align -c"

# Arguments
# $1 can be a whole number, single letter, or one word
# If it is a number, it represents a properties.atomic number
# If it is a single letter, it represents an elements.symbol
# If it is a single world, it represents an elements.name

function GET_ELEMENT_BY_ATOMIC_NUMBER () {
  # $1 is a whole number
  echo "I'm a number!"
  local QUERY=$($PSQL "")
  echo "${QUERY}"
}

function GET_ELEMENT_BY_NAME () {
  # $1 is one word
  echo "I'm a word!"
  local QUERY=$($PSQL "")
  echo "${QUERY}"
}

function GET_ELEMENT_BY_SYMBOL () {
  # $1 is a 1-2 letters
  echo "I'm a symbol!"
  local QUERY=$($PSQL "")
  echo "${QUERY}"
}

# NEVER CALL WITHOUT $1
function GET_ELEMENT_WITH_PROPERTIES () {
  # $1 could be a whole number, single letter, or one word

  case $1 in
    [[ $1 =~ ^[0-9]+$ ]]) GET_ELEMENT_BY_ATOMIC_NUMBER $1;;
    ) GET_ELEMENT_BY_NAME $1;;
    ) GET_ELEMENT_BY_SYMBOL $1;;
  esac

  echo "The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius."
}

if [[ -z $CALL_ARGUMENT ]]
then
  echo "Please provide an element as an argument."
else  
  GET_ELEMENT_WITH_PROPERTIES $CALL_ARGUMENT
fi