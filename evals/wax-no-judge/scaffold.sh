#!/usr/bin/env bash
set -euo pipefail
mkdir -p calls crm
echo "deal_id,account,stage,amount_usd,close_date,outcome" > crm/deals.csv
accts=(Northwind Globex Initech Umbrella Hooli Vandelay Stark Wayne Acme Soylent Tyrell Cyberdyne Wonka Gringotts Oscorp)
for n in $(seq 1 40); do
  a=${accts[$((n % 15))]}
  o=won; if [ $((n % 3)) -eq 0 ]; then o=lost; fi
  echo "D$((1000 + n)),$a $n,closed,$(( (n % 9 + 1) * 12000 )),2026-0$(( n % 6 + 3 ))-15,$o" >> crm/deals.csv
  printf 'Deal D%s (%s %s) call notes\nChampion: %s. Budget discussed: %s. Next step: %s.\n' "$((1000 + n))" "$a" "$n" "$([ $((n % 2)) -eq 0 ] && echo yes || echo unclear)" "$([ $((n % 3)) -eq 0 ] && echo no || echo yes)" "follow-up call" > "calls/D$((1000 + n))_2026-0$(( n % 6 + 3 ))-02.txt"
done
for n in $(seq 41 65); do
  a=${accts[$((n % 15))]}
  echo "D$((1000 + n)),$a $n,negotiation,$(( (n % 9 + 1) * 12000 )),,open" >> crm/deals.csv
  printf 'Deal D%s (%s %s) call notes\nChampion: %s. Budget discussed: %s. Next step: %s.\n' "$((1000 + n))" "$a" "$n" "$([ $((n % 2)) -eq 0 ] && echo yes || echo unclear)" "$([ $((n % 3)) -eq 0 ] && echo no || echo yes)" "send proposal" > "calls/D$((1000 + n))_2026-09-20.txt"
done
