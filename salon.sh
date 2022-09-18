#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c "
echo -e "\n~~~~~ MY SALON ~~~~~\n"
MAIN_MENU(){
if [[ $1 ]]
then
  echo -e $1
 else
 echo -e "\nWelcome to My Salon, how can I help you?"
fi
echo "$($PSQL "SELECT * FROM services")" | while IFS="|" read ID NAME
do
 echo "$ID) $NAME"
done
read SERVICE_ID_SELECTED
SERVICE_NAME_RESULT="$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")"
if [[ -z $SERVICE_NAME_RESULT ]]
then
 MAIN_MENU "\nI could not find that service. What would you like today?"
else
 echo -e "\n What's your phone number?"
 read CUSTOMER_PHONE 
  CUSTOMER_NAME_RESULT="$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")"
  if [[ $CUSTOMER_NAME_RESULT ]]
  then
    CUSTOMER_ID_SELECTED="$($PSQL "SELECT customer_id FROM customers WHERE name = '$CUSTOMER_NAME_RESULT'")" 
   echo -e "\n What time would you like your $SERVICE_NAME_RESULT, $CUSTOMER_NAME_RESULT?"
   read SERVICE_TIME
   echo -e "I have put you down for a $SERVICE_NAME_RESULT at $SERVICE_TIME, $CUSTOMER_NAME_RESULT."
   APPOINTMENT_INSERT="$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID_SELECTED,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")"
  else
   echo -e "\nI don't have a record for that phone number, what's your name?"
   read CUSTOMER_NAME
   CUSTOMER_NAME_INSERT="$($PSQL "INSERT INTO customers(name,phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')")"
   CUSTOMER_ID_SELECTED="$($PSQL "SELECT customer_id FROM customers WHERE name = '$CUSTOMER_NAME'")" 
   echo -e "\n What time would you like your $SERVICE_NAME_RESULT, $CUSTOMER_NAME?"
   read SERVICE_TIME
   echo -e "I have put you down for a $SERVICE_NAME_RESULT at $SERVICE_TIME, $CUSTOMER_NAME."
   APPOINTMENT_INSERT="$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID_SELECTED,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")"
  fi
fi

}
MAIN_MENU

