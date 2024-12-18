#!/usr/bin/env bash

# Fetch CPU usage
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{printf "%.1f%%", 100 - $1}')

# Fetch Memory usage
mem_usage=$(free | awk '/^Mem:/ {printf "%.1f%%", $3/$2 * 100}')

# Output the result for tmux
echo "CPU: $cpu_usage | RAM: $mem_usage"
