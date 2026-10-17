#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon -t -A -c"

echo "~~~~~ MY SALON ~~~~~"
echo -e "\nWelcome to My Salon, how can I help you?"

while true; do
  echo ""
  $PSQL "SELECT service_id, name FROM services ORDER BY service_id" | while IFS="|" read -r SERVICE_ID NAME; do
    echo "$SERVICE_ID) $NAME"
  done

  read SERVICE_ID_SELECTED

  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

  if [[ -z "$SERVICE_NAME" ]]; then
    echo -e "\nI could not find that service. What would you like today?"
  else
    break
  fi
done

echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE

CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

if [[ -z "$CUSTOMER_NAME" ]]; then
  echo -e "\nI don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME
  INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
fi

CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

CLEAN_SERVICE_NAME=$(echo "$SERVICE_NAME" | xargs)
CLEAN_CUSTOMER_NAME=$(echo "$CUSTOMER_NAME" | xargs)

echo -e "\nWhat time would you like your $CLEAN_SERVICE_NAME, $CLEAN_CUSTOMER_NAME?"
read SERVICE_TIME

INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

echo -e "\nI have put you down for a $CLEAN_SERVICE_NAME at $SERVICE_TIME, $CLEAN_CUSTOMER_NAME."
