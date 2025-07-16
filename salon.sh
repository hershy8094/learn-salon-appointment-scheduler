#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t -c"

echo -e '\n~~~~~ MY SALON ~~~~~'
MAIN-MENU () {
  echo -e "\n$1"
  ($PSQL "select service_id, name from services" ) | awk 'NF' | while read ID BAR SERVICE
  do
    echo  "$ID) $SERVICE"
  done
  read SERVICE_ID_SELECTED
  SERVICE=$($PSQL "select name from services where service_id = $SERVICE_ID_SELECTED")
  case $SERVICE_ID_SELECTED in 
    1 | 2 | 3 | 4 | 5)
      echo -e "\nWhat's your phone number?"
      read CUSTOMER_PHONE
      CUSTOMER_NAME=$($PSQL "select name from customers where phone = '$CUSTOMER_PHONE'")
      if [[ -z $CUSTOMER_NAME ]]
      then
        echo -e '\nI don't have a record for that phone number, what's your name?'
        read CUSTOMER_NAME
        OUTPUT=$($PSQL "insert into customers (name, phone) values ('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
      fi
      CUSTOMER_ID=$($PSQL "select customer_id from customers where phone = '$CUSTOMER_PHONE'")
      echo -e "\nWhat time would you like your$SERVICE, $CUSTOMER_NAME?"
      read SERVICE_TIME
      OUTPUT=$($PSQL "insert into appointments (customer_id, service_id, time) values ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
      echo -e "\nI have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
      ;;
    *)
      MAIN-MENU "I could not find that service. What would you like today?"
  esac
}
MAIN-MENU 'Welcome to My Salon, how can I help you?'