# microServiceCICDTest - development Environment

This directory contains the microServiceCICDTest microservice configuration for the development environment.

## Environment Details
- Environment: development
- Port: 5001
- Branch: feature-test
- Version: 257-973600a

## Running the Service
To run this service:
```bash
docker compose --env-file environments/development/microServiceCICDTest/.env up -d
```

## Port Ranges
- Development: 5000-5999
- Staging: 6000-6999
- Production: 7000-7999
