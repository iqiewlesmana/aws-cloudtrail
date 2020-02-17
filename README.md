# cloudtrail-scripts
Scripts to get information from AWS CLoudTrail Lookup Events

List of All Event Name with following information :
 - AWS Access Key used in an event ( AccessKeyId )
 - Event time ( EventTime )
 - Event name ( EventName )
 - AWS Region ( awsRegion )
 - Source IP address ( sourceIPAddress )
 - User name ( Username )
 - Resource type ( ResourceType )
 - Resource name ( ResourceName )

## Requirement
  * AWS CLI 
  * jq https://stedolan.github.io/jq/ ( sudo apt-get install jq )

## How to use
### Function : lookup_eventname, 

** function lookup_eventname | List Event by Username | EventTime | EventName | accessKeyId | Resources | awsRegion | sourceIPAddress |
* ```./cloudtrail.sh lookup_eventname```

** function filterby_ipaddress | Filter the results by source IP address
* ```./cloudtrail.sh filterby_ipaddress```

** function lookupby_resourcetype | Ability to get the list of event by resource type
* ```/cloudtrail.sh lookupby_resourcetype```
