#!/usr/bin/env bash
# IT-MANAGER: read-only host port inventory, run on the exact Docker VM/LXC.
# No changes, no container lifecycle actions or firewall modifications.
set -u
echo '=== Local IP/interface ==='
hostname || true
ip -br address || true
echo '=== All containers, including stopped ==='
docker ps -a --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}' || true
echo '=== Host TCP/UDP listeners ==='
ss -lntup || true
echo '=== Last-known / sequential OSINT TCP candidates ==='
for p in 18893 18894 18895 18896 18897 18898 18899 5001; do
  echo "--- TCP $p ---"
  ss -H -ltn "( sport = :$p )" || true
done
echo '=== Port bindings including stopped Docker containers ==='
docker ps -aq | xargs -r docker inspect --format '{{.Name}} {{json .HostConfig.PortBindings}}' || true
echo 'Read-only inventory complete. No listener does not reserve a port.'
