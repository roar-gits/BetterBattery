#!/bin/zsh
# batt-monitor.sh — Auto-drain battery to target limit
#
# Runs periodically via launchd. When battery is above the batt upper limit,
# disables the power adapter to drain. When battery reaches the lower limit,
# re-enables the adapter. Stays out of the way when limit is set to 100%
# (mobile mode).

BATT="/opt/homebrew/bin/batt"
LOG_TAG="batt-monitor"

# Get current batt configuration
STATUS=$($BATT status 2>&1)

# Parse upper and lower limits
UPPER=$(echo "$STATUS" | grep "Upper limit:" | grep -oE '[0-9]+')
LOWER=$(echo "$STATUS" | grep "Lower limit:" | grep -oE '[0-9]+')

# If limit is 100% (mobile mode), make sure adapter is enabled and exit
if [ "$UPPER" = "100" ]; then
    ADAPTER_DISABLED=$(echo "$STATUS" | grep "Use power adapter" | grep -c "✘")
    if [ "$ADAPTER_DISABLED" -eq 1 ]; then
        $BATT adapter enable >/dev/null 2>&1
        logger -t "$LOG_TAG" "Mobile mode (100%) — re-enabled adapter"
    fi
    exit 0
fi

# Get current charge percentage
CHARGE=$(echo "$STATUS" | grep "Current charge:" | grep -oE '[0-9]+')

# Safety: if we can't read values, do nothing
if [ -z "$UPPER" ] || [ -z "$LOWER" ] || [ -z "$CHARGE" ]; then
    logger -t "$LOG_TAG" "Could not read batt status — skipping"
    exit 0
fi

# Check if adapter is currently disabled (we disabled it to drain)
ADAPTER_DISABLED=$(echo "$STATUS" | grep "Use power adapter" | grep -c "✘")

if [ "$ADAPTER_DISABLED" -eq 1 ]; then
    # Adapter is disabled (draining). Check if we've hit the lower limit.
    if [ "$CHARGE" -le "$LOWER" ]; then
        $BATT adapter enable >/dev/null 2>&1
        logger -t "$LOG_TAG" "Reached ${CHARGE}% (lower limit ${LOWER}%) — re-enabled adapter"
    fi
elif [ "$CHARGE" -gt "$UPPER" ]; then
    # Battery is above the limit and adapter is enabled. Start draining.
    $BATT adapter disable >/dev/null 2>&1
    logger -t "$LOG_TAG" "At ${CHARGE}% (above limit ${UPPER}%) — disabled adapter to drain"
fi
