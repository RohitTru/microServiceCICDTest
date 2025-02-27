### Initial set up
To enable linters and Pre-commit hooks lets start off by running

./setup.sh



### If you want to create a feature branch:
git checkout -b feature-{name} 
git push origin feature-{name}
git pull origin feature-{name} --rebase


### If you want to tear down and delete your feature branch
git branch -D feature-{name}
git push origin --delete feature-{name}



### Running locally if you have docker installed
docker compose --env-file ./feature-{name}/.env up -d
docker compose --env-file ./feature-{name}/.env down


### If you to access the feature through the CloudFlared tunnel (only for devops atm)
curl -I http://feature-{name}.emerginary.com/health
























## Other commands that are just notes:

### If you need to create the microservices docker network
docker network create app-network


### In case your git-repo on the master branch is behind changes made to the github

git stash
git pull origin master --rebase
git stash pop
git add -A
git commit -m "your commit message"
git push origin master


