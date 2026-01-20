% Team destination optimization.


destination(seattle).
destination(montreal).
destination(san_francisco).
destination(vancouver).
destination(toronto).
destination(los_angeles).
destination(boston).
destination(salt_lake_city).
destination(reykjavik).
destination(nyc).
destination(dublin).
destination(london).
destination(paris).
destination(barcelona).

people(paris,2).
people(barcelona,1).
people(madrid,1).
people(san_francisco,1).
people(san_diego,1).
people(seattle,2).
people(salt_lake_city,2).
people(columbia_mo,1).

% Times are in quarter-hours (time_qh = hours * 4) to keep integers.
route(paris,seattle,41).
route(paris,montreal,26).
route(paris,san_francisco,45).
route(paris,vancouver,40).
route(paris,toronto,28).
route(paris,los_angeles,47).
route(paris,boston,28).
route(paris,salt_lake_city,44).
route(paris,reykjavik,14).
route(paris,nyc,30).
route(paris,dublin,6).
route(paris,london,5).
route(paris,paris,0).
route(paris,barcelona,7).

route(barcelona,seattle,44).
route(barcelona,montreal,28).
route(barcelona,san_francisco,48).
route(barcelona,vancouver,43).
route(barcelona,toronto,30).
route(barcelona,los_angeles,49).
route(barcelona,boston,30).
route(barcelona,salt_lake_city,47).
route(barcelona,reykjavik,16).
route(barcelona,nyc,32).
route(barcelona,dublin,10).
route(barcelona,london,9).
route(barcelona,paris,7).
route(barcelona,barcelona,0).

route(madrid,seattle,43).
route(madrid,montreal,27).
route(madrid,san_francisco,47).
route(madrid,vancouver,42).
route(madrid,toronto,29).
route(madrid,los_angeles,48).
route(madrid,boston,29).
route(madrid,salt_lake_city,46).
route(madrid,reykjavik,15).
route(madrid,nyc,31).
route(madrid,dublin,11).
route(madrid,london,10).
route(madrid,paris,8).
route(madrid,barcelona,5).

route(san_francisco,seattle,8).
route(san_francisco,montreal,21).
route(san_francisco,san_francisco,0).
route(san_francisco,vancouver,9).
route(san_francisco,toronto,20).
route(san_francisco,los_angeles,5).
route(san_francisco,boston,23).
route(san_francisco,salt_lake_city,8).
route(san_francisco,reykjavik,32).
route(san_francisco,nyc,22).
route(san_francisco,dublin,41).
route(san_francisco,london,42).
route(san_francisco,paris,45).
route(san_francisco,barcelona,48).
route(san_diego,seattle,11).
route(san_diego,montreal,20).
route(san_diego,san_francisco,5).
route(san_diego,vancouver,11).
route(san_diego,toronto,21).
route(san_diego,los_angeles,4).
route(san_diego,boston,22).
route(san_diego,salt_lake_city,9).
route(san_diego,reykjavik,33).
route(san_diego,nyc,21).
route(san_diego,dublin,42).
route(san_diego,london,43).
route(san_diego,paris,46).
route(san_diego,barcelona,49).

route(seattle,seattle,0).
route(seattle,montreal,20).
route(seattle,san_francisco,8).
route(seattle,vancouver,3).
route(seattle,toronto,21).
route(seattle,los_angeles,11).
route(seattle,boston,22).
route(seattle,salt_lake_city,8).
route(seattle,reykjavik,30).
route(seattle,nyc,21).
route(seattle,dublin,37).
route(seattle,london,38).
route(seattle,paris,41).
route(seattle,barcelona,44).
route(salt_lake_city,seattle,8).
route(salt_lake_city,montreal,17).
route(salt_lake_city,san_francisco,8).
route(salt_lake_city,vancouver,9).
route(salt_lake_city,toronto,18).
route(salt_lake_city,los_angeles,8).
route(salt_lake_city,boston,19).
route(salt_lake_city,salt_lake_city,0).
route(salt_lake_city,reykjavik,31).
route(salt_lake_city,nyc,18).
route(salt_lake_city,dublin,40).
route(salt_lake_city,london,41).
route(salt_lake_city,paris,44).
route(salt_lake_city,barcelona,47).

route(columbia_mo,seattle,4).
route(columbia_mo,montreal,11).
route(columbia_mo,san_francisco,16).
route(columbia_mo,vancouver,35).
route(columbia_mo,toronto,11).
route(columbia_mo,los_angeles,8).
route(columbia_mo,boston,10).
route(columbia_mo,salt_lake_city,39).
route(columbia_mo,reykjavik,11).
route(columbia_mo,nyc,16).
route(columbia_mo,dublin,16).
route(columbia_mo,london,26).
route(columbia_mo,paris,36).
route(columbia_mo,barcelona,18).

city(C) :- destination(C).
city(C) :- people(C,_).

1 { offsite_location(C) : destination(C) } 1.

assign(S,D) :- people(S,_), offsite_location(D).
total_qh(T) :- T = #sum { W*P : assign(S,D), people(S,P), route(S,D,W) }.

:~ offsite_location(D), total_qh(T). [T]

#show offsite_location/1.
#show total_qh/1.
