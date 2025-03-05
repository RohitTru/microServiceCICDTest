# Microservices CI/CD Test

This repository demonstrates a CI/CD workflow for managing multiple microservices with automated port assignments and environment transitions.

## Directory Structure

```
environments/
  development/
    microServiceCICDTest/  # Your microservice name
      feature-port-test-5/
        .env (port 5001)
  staging/
    microServiceCICDTest/
      .env (port 6000)
  production/
    microServiceCICDTest/
      .env (port 7000)
```

## Port Ranges

Each environment has its own port range to prevent conflicts:
- Development: 5000-5999
- Staging: 6000-6999
- Production: 7000-7999

## Working with Feature Branches

### Creating a Feature Branch
```bash
git checkout -b feature-{name} 
git push origin feature-{name}
git pull origin feature-{name} --rebase
```

### Running Your Feature Branch Locally
```bash
# The .env file will be in environments/development/microservice-name/feature-name/
docker compose --env-file environments/development/microservice-name/feature-name/.env up -d
```

### Running Staging Environment
```bash
# The .env file will be in environments/staging/microservice-name/
docker compose --env-file environments/staging/microservice-name/.env up -d
```

### Running Production Environment
```bash
# The .env file will be in environments/production/microservice-name/
docker compose --env-file environments/production/microservice-name/.env up -d
```

### Cleaning Up Feature Branches
```bash
git branch -D feature-{name}
git push origin --delete feature-{name}
```

## Environment Transitions

1. Development to Staging:
   - Create PR from feature branch to staging
   - Port will be migrated from 5xxx to 6xxx range
   - Feature branch port will be released

2. Staging to Production:
   - Create PR from staging to master
   - Port will be migrated from 6xxx to 7xxx range
   - Staging port will be released

## Additional Setup

### Creating the Docker Network
```bash
docker network create app-network
```

### Setting Up Development Environment
```bash
./setup.sh
```

## Understanding the Workflow

1. When you create a feature branch:
   - Gets assigned a port in the 5000-5999 range
   - Creates environment files in `environments/development/microservice-name/feature-name/`

2. When you merge to staging:
   - Gets assigned a port in the 6000-6999 range
   - Creates environment files in `environments/staging/microservice-name/`
   - Releases the development port

3. When you merge to production (master):
   - Gets assigned a port in the 7000-7999 range
   - Creates environment files in `environments/production/microservice-name/`
   - Releases the staging port

Each environment directory contains:
- `.env` file with environment-specific configuration
- `README.md` with environment details and instructions
- Application code and tests
- Test reports and coverage data

## Troubleshooting

If you need to sync your local branch with master:
```bash
git stash
git pull origin master --rebase
git stash pop
git add -A
git commit -m "your commit message"
git push origin master
```


