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

START=$(date --date="2 day ago" +"%Y-%m-%dT%H:%M:%SZ")
MAX_RESULTS=5
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
echo "Pulling cloudtrail from a 2 days ago ($START)"

lookup_eventname () {
  #Return certains information
  read -p "Enter AttributeKey :" Akey
  read -p "Enter AttributeValue :" Avalue
  echo "Looking for Access Key used in event : $Avalue"
  aws cloudtrail lookup-events --lookup-attributes  AttributeKey="$Akey",AttributeValue="$Avalue" --max-results "$MAX_RESULTS" --query 'Events[].{username:Username,EventTime:EventTime,eventName:EventName,accesskey:AccessKeyId,resourceName:(Resources[0].ResourceName),resourceType:(Resources[0].ResourceType)}' --output table --start-time "$START"

}


filterby_ipaddress () {
  #Filter the results by sourceIPAddress & AccessKeyId
  read -p "Enter to Filter by source IP Address :" ipaddress
  read -p "Enter to Filter by Access Key ID :" accesskeyid
  read -p "Enter AttributeValue :" Avalue
  echo "Filter All Event Name $Avalue By Access Key ID $accesskeyid & with source IP Address $ipaddress"
  aws cloudtrail lookup-events --lookup-attributes  AttributeKey=EventName,AttributeValue="$Avalue" --start-time "$START" --max-results "$MAX_RESULTS" --output json | jq -r '.Events[] | .CloudTrailEvent' | jq -r 'select(if ((.userIdentity.accessKeyId | startswith("'$accesskeyid'")) and (.sourceIPAddress | startswith("'$ipaddress'"))) then false else true end)'
}

lookupby_resourcetype () {
  #Ability to get the list of event by resource type
  read -p "Enter AttributeValue :" Avalue
  echo "List of All Event By Resource Type : $Avalue"
  aws cloudtrail lookup-events --lookup-attributes AttributeKey=ResourceType,AttributeValue="$Avalue" --max-results "$MAX_RESULTS" --query 'Events[].{Event_Name:EventName,Resource_Type:(Resources[0].ResourceType)}' --output table --start-time "$START"

}

