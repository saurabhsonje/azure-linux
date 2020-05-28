#!/bin/bash

/usr/bin/java -jar /opt/nexus/lib/support/nexus-orient-console.jar "connect plocal:/opt/nexusdata/nexus3/db/security/ admin admin;\
 select status from user where id ='admin'"  | tail -4 | head -1 | cut -d'|' -f3 >  /tmp/admin_status

