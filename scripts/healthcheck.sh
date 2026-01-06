#!/bin/bash

###############################################################################
# Health Check Script
# Usage: ./healthcheck.sh <health_endpoint_url> [max_retries] [retry_interval]
###############################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Arguments
HEALTH_URL=${1:-"http://localhost:8081/actuator/health"}
MAX_RETRIES=${2:-30}
RETRY_INTERVAL=${3:-5}

echo -e "${YELLOW}========================================${NC}"
echo -e "${YELLOW}Health Check Started${NC}"
echo -e "${YELLOW}Endpoint: $HEALTH_URL${NC}"
echo -e "${YELLOW}Max Retries: $MAX_RETRIES${NC}"
echo -e "${YELLOW}========================================${NC}"

# Function to check health
check_health() {
    response=$(curl -s -o /dev/null -w "%{http_code}" "$HEALTH_URL" 2>/dev/null || echo "000")
    echo "$response"
}

# Retry loop
attempt=1
while [ $attempt -le $MAX_RETRIES ]; do
    echo -e "${YELLOW}Attempt $attempt/$MAX_RETRIES...${NC}"

    http_code=$(check_health)

    if [ "$http_code" == "200" ]; then
        echo -e "${GREEN}========================================${NC}"
        echo -e "${GREEN}✅ Health check passed!${NC}"
        echo -e "${GREEN}HTTP Status: $http_code${NC}"

        # Get detailed health info
        health_details=$(curl -s "$HEALTH_URL" 2>/dev/null || echo "{}")
        echo -e "${GREEN}Health Details:${NC}"
        echo "$health_details" | python3 -m json.tool 2>/dev/null || echo "$health_details"

        echo -e "${GREEN}========================================${NC}"
        exit 0
    elif [ "$http_code" == "503" ]; then
        echo -e "${YELLOW}Service unavailable (503), retrying...${NC}"
    elif [ "$http_code" == "000" ]; then
        echo -e "${YELLOW}Connection failed, retrying...${NC}"
    else
        echo -e "${YELLOW}Unexpected status code: $http_code, retrying...${NC}"
    fi

    if [ $attempt -lt $MAX_RETRIES ]; then
        echo -e "${YELLOW}Waiting $RETRY_INTERVAL seconds before next attempt...${NC}"
        sleep $RETRY_INTERVAL
    fi

    ((attempt++))
done

# If we reach here, all retries failed
echo -e "${RED}========================================${NC}"
echo -e "${RED}❌ Health check failed!${NC}"
echo -e "${RED}Endpoint: $HEALTH_URL${NC}"
echo -e "${RED}Max retries ($MAX_RETRIES) exceeded${NC}"
echo -e "${RED}========================================${NC}"

exit 1