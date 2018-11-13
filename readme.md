# node-chromium

WIP: A Docker image built from `node-alpine` with `chromium` installed. It is made to use with Angular projects for local development and continuous integration with GitLab CI.

## Development

Use `node-chromium` for local development. 

In `Dockerfile`:

```dockerfile
FROM armno/node-chromium:10.13.0-alpine

# set the working directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# add `node_modules` to PATH
ENV PATH /usr/src/app/node_modules/.bin:$PATH

# install and cache dependecies
COPY package*.json /usr/src/app/
RUN npm install

# add app
COPY . /usr/src/app
```

and `docker-compose.yml`

```yml
version: '3'

services:
  app:
    container_name: app
    build:
      context: .
    volumes:
      - '.:/usr/src/app'
      - '/usr/src/app/node_modules'
    command: npm start
    ports:
      - '4200:4200'
```

## CI (with GitLab CI)

In `.gitlab-ci.yml`

```yml
image: armno/node-chromium:10.13.0-alpine

unit_test:
  stage: test
  before_script:
    - npm install
  script: npm run test:ci
```
