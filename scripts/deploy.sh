#!/bin/bash

###############################################################################
# Talentix Platform Deployment Script
# Usage: ./deploy.sh [dev|prod]
###############################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get environment argument
ENVIRONMENT=${1:-dev}

# Validate environment
if [[ "$ENVIRONMENT" != "dev" && "$ENVIRONMENT" != "prod" ]]; then
    echo -e "${RED}Error: Environment must be 'dev' or 'prod'${NC}"
    echo "Usage: ./deploy.sh [dev|prod]"
    exit 1
fi

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Deploying Talentix Platform${NC}"
echo -e "${GREEN}Environment: $ENVIRONMENT${NC}"
echo -e "${GREEN}========================================${NC}"

# Load environment variables
if [ -f .env ]; then
    echo -e "${YELLOW}Loading environment variables...${NC}"
    export $(cat .env | grep -v '^#' | xargs)
else
    echo -e "${YELLOW}Warning: .env file not found. Using defaults.${NC}"
fi

# Set docker-compose file based on environment
if [ "$ENVIRONMENT" == "prod" ]; then
    COMPOSE_FILE="docker-compose.prod.yml"
    CONTAINER_PREFIX="talentix-prod"
else
    COMPOSE_FILE="docker-compose.yml"
    CONTAINER_PREFIX="talentix-dev"
fi

# Stop existing containers
echo -e "${YELLOW}Stopping existing containers...${NC}"
docker-compose -f "$COMPOSE_FILE" down || true

# Remove old containers (optional)
echo -e "${YELLOW}Removing old containers...${NC}"
docker container prune -f || true

# Pull latest images (for production)
if [ "$ENVIRONMENT" == "prod" ]; then
    echo -e "${YELLOW}Pulling latest images...${NC}"
    docker-compose -f "$COMPOSE_FILE" pull
fi

# Start containers
echo -e "${YELLOW}Starting containers...${NC}"
docker-compose -f "$COMPOSE_FILE" up -d

# Wait for services to be healthy
echo -e "${YELLOW}Waiting for services to be healthy...${NC}"
sleep 10

# Check MySQL health
echo -e "${YELLOW}Checking MySQL health...${NC}"
MYSQL_CONTAINER="talentix-mysql-$ENVIRONMENT"
for i in {1..30}; do
    if docker exec "$MYSQL_CONTAINER" mysqladmin ping -h localhost -u root -p"${MYSQL_ROOT_PASSWORD:-root}" --silent; then
        echo -e "${GREEN}MySQL is healthy!${NC}"
        break
    fi
    echo "Waiting for MySQL... ($i/30)"
    sleep 2
done

# Check application health
echo -e "${YELLOW}Checking application health...${NC}"
if [ "$ENVIRONMENT" == "prod" ]; then
    APP_PORT=8080
else
    APP_PORT=8081
fi

for i in {1..30}; do
    if curl -f http://localhost:$APP_PORT/actuator/health > /dev/null 2>&1; then
        echo -e "${GREEN}Application is healthy!${NC}"
        break
    fi
    echo "Waiting for application... ($i/30)"
    sleep 3
done

# Display running containers
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Running Containers:${NC}"
docker-compose -f "$COMPOSE_FILE" ps

# Display logs
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Recent Application Logs:${NC}"
docker-compose -f "$COMPOSE_FILE" logs --tail=20 app

# Final status
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Deployment completed successfully!${NC}"
echo -e "${GREEN}Environment: $ENVIRONMENT${NC}"
echo -e "${GREEN}Application URL: http://localhost:$APP_PORT${NC}"
echo -e "${GREEN}Health Check: http://localhost:$APP_PORT/actuator/health${NC}"
echo -e "${GREEN}API Endpoints: http://localhost:$APP_PORT/api/employees${NC}"
echo -e "${GREEN}========================================${NC}"

exit 0