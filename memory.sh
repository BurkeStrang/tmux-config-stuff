mem_usage=$(free | awk '/^Mem:/ {printf "%.1f%%", $3/$2 * 100}')
echo "$mem_usage"
