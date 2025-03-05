# microServiceCICDTest - production Environment

This directory contains the microServiceCICDTest microservice configuration for the production environment.

## Environment Details
- Environment: production
- Port: 7002
- Branch: master
- Version: 231-a2aa5f2

## Running the Service
To run this service:
```bash
docker compose --env-file environments/production/microServiceCICDTest/.env up -d
```

## Port Ranges
- Development: 5000-5999
- Staging: 6000-6999
- Production: 7000-7999
