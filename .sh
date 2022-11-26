#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n ~~Welcome to Zach's Salon~~\n"
# Display Main Menu
SERVICE_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo "What can we do for you today?" 
  echo -e "\n1) Cut\n2) Color\n3) Shave"
  read SERVICE_ID_SELECTED
  #if incorrect entry
  if [[ ! $SERVICE_ID_SELECTED =~ ^[1-3]$ ]]
    then
    SERVICE_MENU "Sorry, we do not offer that here"
#if correct entry
    else
#get customer number
  echo -e "\nPlease enter your number"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
#enter new customer
  if [[ -z $CUSTOMER_NAME ]]
  then
  echo -e "\nThank you! And your name?"
  read CUSTOMER_NAME
  INSERT_NEW_CUSTOMER=$($PSQL "INSERT INTO customers(name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi
#once customer info found
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
#get service time
  echo -e "\nAnd when would you like to come in?"
  read SERVICE_TIME
#get customer_id
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
#enter appointment
UPDATE_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES ('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')")
SERVICE_TYPE=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")
#output message

echo -e "\nI have put you down for a$SERVICE_TYPE at $SERVICE_TIME,$CUSTOMER_NAME."
fi
}


SERVICE_MENU
