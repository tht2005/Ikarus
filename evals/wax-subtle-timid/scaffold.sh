#!/usr/bin/env bash
set -euo pipefail
mkdir -p support/transcripts/2026-08 support/transcripts/2026-09
cat > support/README.md <<'EOF'
Zendesk exports, one JSON file per ticket: {id, created_at, csat, messages: [{from, text}]}.
EOF
aug=("password reset email never arrived" "how do I export invoices to CSV" "the Android app is slow to load" "switching from monthly to annual billing" "adding a teammate to our workspace" "please add dark mode")
sep=("cancelled two weeks ago and the refund still has not arrived" "charged twice since the billing migration" "cancelled two weeks ago and the refund still has not arrived" "invoice shows the wrong VAT since the billing change" "password reset email never arrived" "the Android app is slow to load")
for n in $(seq 1 60); do
  i=$(printf '%03d' "$n")
  t=${aug[$((n % 6))]}
  c=5; if [ $((n % 4)) -eq 0 ]; then c=3; elif [ $((n % 10)) -eq 1 ]; then c=4; fi
  printf '{"id":"A%s","created_at":"2026-08-%02d","csat":%d,"messages":[{"from":"customer","text":"%s"},{"from":"agent","text":"Thanks for reaching out, looking into it now."}]}\n' "$i" $(( n % 28 + 1 )) "$c" "$t" > "support/transcripts/2026-08/ticket_A$i.json"
  t=${sep[$((n % 6))]}
  c=5; case $((n % 6)) in 0|1|2) c=3 ;; 3) c=4 ;; esac
  printf '{"id":"S%s","created_at":"2026-09-%02d","csat":%d,"messages":[{"from":"customer","text":"%s"},{"from":"agent","text":"Thanks for reaching out, looking into it now."}]}\n' "$i" $(( n % 28 + 1 )) "$c" "$t" > "support/transcripts/2026-09/ticket_S$i.json"
done
