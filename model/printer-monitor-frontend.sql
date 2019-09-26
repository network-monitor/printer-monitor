-- 1. IP PRINTER

-- 2. UPTIME
SELECT last("sysUpTime") / 100 FROM "printer" WHERE ("agent_host" =~ /^()$/) AND time >= now() - 6h

-- 3. SUPPLIES
SELECT last("prtMarkerSuppliesLevel") AS "level", 
       last("prtMarkerSuppliesMaxCapacity") AS "capacity", 
	   mean("prtMarkerSuppliesLevel") *100 / mean("prtMarkerSuppliesMaxCapacity") AS "remaining" 
  FROM "printer" 
 WHERE ("agent_host" =~ /^$ip$/) 
   AND $timeFilter 
 GROUP BY "prtMarkerSuppliesDescription"

-- 4. IMPRESSIONS
SELECT last("prtMarkerLifeCount") 
  FROM "printer" 
 WHERE ("agent_host" =~ /^()$/) 
   AND time >= now() - 6h

-- 5. PRINTER UPTIME
SELECT mean("sysUpTime") / 100 
  FROM "printer" 
 WHERE ("agent_host" =~ /^()$/) 
   AND time >= now() - 6h 
 GROUP BY time(5m), "hrDeviceDescr", "agent_host" fill(null)

-- 6. COVER STATUS
SELECT mean("prtCoverStatus") 
  FROM "printer" 
 WHERE ("agent_host" =~ /^()$/) 
   AND time >= now() - 6h 
GROUP BY time(5m), "agent_host", "prtCoverDescription" fill(null)

-- 7. PRINTED PAGES
SELECT derivative(mean("prtMarkerLifeCount"), 5m) 
  FROM "printer" 
 WHERE ("agent_host" =~ /^()$/) 
   AND time >= now() - 6h 
 GROUP BY time(5m), "hrDeviceDescr", "agent_host" fill(none)

-- 8. SUPPLIES REMAINING
SELECT mean("prtMarkerSuppliesLevel") *100 / mean("prtMarkerSuppliesMaxCapacity") 
  FROM "printer" 
 WHERE ("agent_host" =~ /^$ip$/) 
   AND $timeFilter 
 GROUP BY time(5m), "agent_host", "prtMarkerSuppliesDescription" fill(none)

-- measurement: 
-- -- printer
-- --   agent_host : (195.1.1.201)
-- --   time: 2019-09-19 13:30:00
-- --   hrDeviceDescr: COLOR PRINTER
-- --   sysUpTime : 30000 seconds 
-- --   prtMarkerSuppliesDescription: Black toner
-- --   prtMarkerSuppliesLevel: 112
-- --   prtMarkerSuppliesMaxCapacity: 1000
-- --   prtMarkerLifeCount: 23
-- --   prtCoverDescription: FRONT COVER 
-- --   prtCoverStatus: CLOSED

-- traffic,etype=800,as_src=64496,as_dst=64500,peer_as_src=64496,peer_as_dst=64500 bytes=153578160128
-- printer,agent_host=195.1.1.93,hrDeviceDescr=NPI059436,sysUpTime=64500,prtCoverStatus=4,peer_aprtCoverDescription=\"door closed\" bytes=153578160128

SELECT last("sysUpTime") / 100 FROM "printer" WHERE "agent_host" = "195.1.1.233"
