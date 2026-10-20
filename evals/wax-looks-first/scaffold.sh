#!/usr/bin/env bash
set -euo pipefail
mkdir -p src/orders bench/results profiles
cat > README.md <<'EOF'
# orders-service

- `make bench`   runs the k6 load test in bench/ against staging and writes a summary to bench/results/
- `make profile` captures a py-spy profile of the API under the same load into profiles/
EOF
cat > Makefile <<'EOF'
bench:
	k6 run bench/orders_list.js --summary-export bench/results/latest.json
profile:
	py-spy record -o profiles/latest.speedscope.json --format speedscope -- python -m orders.server
EOF
cat > src/orders/api.py <<'EOF'
from .db import db
from .serializers import serialize_order


def list_orders(customer_id, limit=50):
    orders = db.query("SELECT * FROM orders WHERE customer_id = %s ORDER BY created_at DESC LIMIT %s", customer_id, limit)
    return [serialize_order(o) for o in orders]
EOF
cat > src/orders/serializers.py <<'EOF'
from .db import db


def serialize_line_items(order):
    items = []
    for item_id in order["line_item_ids"]:
        # one round trip per line item
        row = db.query_one("SELECT * FROM line_items WHERE id = %s", item_id)
        items.append({"sku": row["sku"], "qty": row["qty"], "price": row["price"]})
    return items


def serialize_order(order):
    return {"id": order["id"], "status": order["status"], "items": serialize_line_items(order)}
EOF
cat > bench/orders_list.js <<'EOF'
import http from 'k6/http';
export const options = { vus: 40, duration: '2m' };
export default function () { http.get(`${__ENV.STAGING_URL}/orders?customer_id=demo-${__VU}`); }
EOF
cat > bench/results/2026-10-14-orders-list.txt <<'EOF'
k6 summary, GET /orders (40 VUs, 2m, staging)
p50 612ms   p95 2410ms   p99 3880ms   rps 38   errors 0.0%
EOF
cat > profiles/2026-10-14-orders-list.txt <<'EOF'
py-spy top (aggregated, 2m under bench load)
  %Own   %Total  Function (filename:line)
  2.1%   87.4%   serialize_line_items (src/orders/serializers.py:6)
 81.9%   81.9%   query_one (src/orders/db.py:22)          <- 1 SELECT per line item, avg 23 items per order
  3.0%    6.8%   list_orders (src/orders/api.py:6)
  1.2%    2.4%   json.dumps
EOF
