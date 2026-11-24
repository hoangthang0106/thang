#!/usr/bin/env bash
# IT-MANAGER / read-only inventory for the current Docker host.
# NO deploy / stop / delete / firewall change / external scan.
set -u
printf '\n=== Hostname and local IP addresses ===\n'
hostname || true
ip -br address || true
printf '\n=== All Docker containers including stopped ===\n'
docker ps -a --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}' || true
printf '\n=== Docker Compose projects ===\n'
docker compose ls -a || true
printf '\n=== TCP/UDP listeners on THIS host ===\n'
ss -lntup || true
printf '\n=== Proposed OSINT ports (TCP) and next candidates ===\n'
for p in 18994 18995 18996 18997 18998 5001; do
  echo "---- TCP port $p ----"
  ss -H -ltn "( sport = :$p )" || true
done
printf '\n=== Published port reservations, including stopped containers ===\n'
docker ps -aq | xargs -r docker inspect --format '{{.Name}} {{json .HostConfig.PortBindings}}' || true
printf '\nRead-only inventory complete. No listener does NOT guarantee the port stays free.\n'
