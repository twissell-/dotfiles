. /sys/class/power_supply/BAT0/uevent &> /dev/null

echo "${POWER_SUPPLY_CAPACITY}% ${POWER_SUPPLY_STATUS}"

