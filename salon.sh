#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --no-align --tuples-only -c"



MAIN_MENU() {
  # write all services raws in formated form
  SERVICES=$($PSQL "SELECT * FROM services;")
  echo "$SERVICES" | sed 's/|/) /'  

  echo "Enter service id:"
  read SERVICE_ID_SELECTED
  SERVICE_ID_RESULT=$($PSQL "SELECT DISTINCT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED;")
  if [[ -z $SERVICE_ID_RESULT ]]
  then
    MAIN_MENU     
  else
    CUSTOMER_MENU
  fi
}
CUSTOMER_MENU() {
  # read customer phone number
  echo "Enter phone number"
  read CUSTOMER_PHONE
  # look for customer_name in database
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE';")
  if [[ -z $CUSTOMER_NAME ]]
  then
    # insert new customer into customers table
    echo "Enter name:"
    read CUSTOMER_NAME
    $($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME');")
  fi
  # read appointment date
  echo "Enter time:"
  read SERVICE_TIME
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME';")
  SERVICE_ID=$SERVICE_ID_SELECTED
  $PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID, '$SERVICE_TIME');"
  
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID;")
  echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU