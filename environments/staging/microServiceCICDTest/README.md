# microServiceCICDTest - staging Environment

This directory contains the microServiceCICDTest microservice configuration for the staging environment.

## Environment Details
- Environment: staging
- Port: 6003
- Branch: feature-test
- Version: 261-e975a6b

## Running the Service
To run this service:
```bash
docker compose --env-file environments/staging/microServiceCICDTest/.env up -d
```

## Port Ranges
- Development: 5000-5999
- Staging: 6000-6999
- Production: 7000-7999
