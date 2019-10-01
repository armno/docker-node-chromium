# node-chromium

A Docker image built from `node` and `node-alpine` with `chromium` installed.

It is made to use with Angular projects for local development and continuous integration with GitLab CI.

It also comes with `python` installed, in case it is needed to rebuild `node-sass` dependency's binary from the source code.

## Tags

### node-alpine:

- `latest`, `11.6.0-alpine` ([Dockerfile](https://github.com/armno/docker-node-chromium/blob/master/Dockerfile)) - an alpine image with Chromium (68) installed.
- `10.15.0-alpine` ([Dockerfile](https://github.com/armno/docker-node-chromium/blob/node-10-alpine/Dockerfile)) - a version with node 10.

### node

- `11.6.0` ([Dockerfile](https://github.com/armno/docker-node-chromium/blob/node/Dockerfile)) - a standard node image with the latest Google Chrome (71) installed.. i think 🤔
- `10.16.0` ([Dockerfile](https://github.com/armno/docker-node-chromium/blob/node-10/Dockerfile)) - same configurations but for node 10.x

**TL;DR**: If you are using CodecepJS with Puppeteer driver, use `11.6.0`. Otherwise, use the alpine version.

The alpine image works with local dev server (`$ ng serve`), unit testing with karma (`$ ng test`)
on both regular and headless Chrome.

The standard node image (non-alpine version) is created so it can run [CodeceptJS](https://codecept.io/) E2E tests
with [Puppeteer](https://codecept.io/puppeteer) driver.
The issue was that the alpine image is currently stuck with Chromium 68 and Puppeteer failed to launch Chromium
on my E2E tests.

---

## Development

Use `node-chromium` for local development.

In `Dockerfile`:

```dockerfile
FROM armno/node-chromium:11.6.0

# set the working directory
RUN mkdir -p /app
WORKDIR /app

# add `node_modules` to PATH
ENV PATH /app/node_modules/.bin:$PATH

# install and cache dependecies
COPY package*.json /app/
RUN npm install

# add app
COPY . /app
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
      - '.:/app'
      - '/app/node_modules'
    command: npm start
    ports:
      - '4200:4200'
```

## CI (with GitLab CI)

In `.gitlab-ci.yml`

```yml
image: armno/node-chromium:11.6.0

unit_test:
  stage: test
  before_script:
    - npm install
  script: npm run test:ci
```

## License

[Public Domain](LICENSE)

-----

### Personal notes

(I have to note this to my future self on how to do these things again).

To make a new image/tag on dockerhub:

0. create a new branch if needed.
  - from [`origin/alpine`](https://github.com/armno/docker-node-chromium/tree/alpine) branch for alpine image
  - from [`origin/node`](https://github.com/armno/docker-node-chromium/tree/node) branch for full node image
1. create/update `Dockerfile` with the desired `<NODE_VERSION>`.
2. build the image locally `$ docker build --tag armno/node-chromium:<NODE_VERSION> .`
3. push to dockerhub `$ docker push armno/node-chromium:<NODE_VERSION>`
