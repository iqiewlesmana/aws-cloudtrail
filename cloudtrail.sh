#!/bin/sh

#This Script return the following information on below :
# - AWS Access Key used in an event ( AccessKeyId )
# - Event time ( EventTime )
# - Event name ( EventName )
# - AWS Region ( awsRegion )
# - Source IP address ( sourceIPAddress )
# - User name ( Username )
# - Resource type ( ResourceType )
# - Resource name ( ResourceName )

START=$(date --date="5 day ago" +"%Y-%m-%dT%H:%M:%SZ")

MAX_RESULTS=1
echo "List of All Event Name with following information :
 - AWS Access Key used in an event ( AccessKeyId )
 - Event time ( EventTime )
 - Event name ( EventName )
 - AWS Region ( awsRegion )
 - Source IP address ( sourceIPAddress )
 - User name ( Username )
 - Resource type ( ResourceType )
 - Resource name ( ResourceName )
"
echo "Pulling cloudtrail from ($START)"
echo "max results "$MAX_RESULTS""

lookup_eventname () {
  #Return certains information
  read -p "Enter AttributeKey :" Akey
  read -p "Enter AttributeValue :" Avalue
  echo "Looking for Access Key used in event : $Avalue"
  aws cloudtrail lookup-events --lookup-attributes AttributeKey="$Akey",AttributeValue="$Avalue"  --start-time "$START" --output json | jq -r '.Events | .[]' | jq '{username: .Username,Event_Time: .EventTime | strftime("%F %T"),Event_Name: .EventName, Access_Key: .AccessKeyId,resource_Name: .Resources[0]}'
  aws cloudtrail lookup-events --lookup-attributes AttributeKey="$Akey",AttributeValue="$Avalue"  --start-time "$START" --output json | jq -r '.Events | .[] | .CloudTrailEvent' | jq '{Region: .awsRegion,IP_Address:.sourceIPAddress,Event_Name:.eventName}' | jq -s 'add'
}

filterby_ipaddress () {
  #Filter event results by sourceIPAddress
  read -p "Enter to Filter by source IP Address :" ipaddress
  read -p "Enter AttributeValue :" Avalue
  echo "Filter All Event Name with source IP Address $ipaddress"
  aws cloudtrail lookup-events --lookup-attributes AttributeKey=EventName,AttributeValue="$Avalue" --start-time "$START" --max-results "$MAX_RESULTS" --output json | jq -r '.Events[] | .CloudTrailEvent' | jq -r 'select(.sourceIPAddress == "'$ipaddress'")'
}

lookupby_resourcetype () {
  #Ability to get the list of event by resource type
  read -p "Enter AttributeValue :" Avalue
  echo "List of All Event By Resource Type : $Avalue"
  aws cloudtrail lookup-events --lookup-attributes AttributeKey=ResourceType,AttributeValue="$Avalue" --max-results "$MAX_RESULTS" --output json --start-time "$START" | jq -r '.Events[]' | jq '{Event_Name: .EventName,Resource_Type: .Resources[]}'
}

$1 $2 $3
