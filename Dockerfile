
# 
FROM node:14.15.1-alpine AS base

LABEL maintainer = "danydodson@gmail.com"
LABEL org.opencontainers.image.source https://github.com/danydodson/whale-demo
LABEL org.opencontainers.image.authors danydodson@gmail.com


RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app
WORKDIR /home/node/app
USER node
COPY package.json .
COPY yarn.lock .
RUN yarn --pure-lockfile

# 
FROM base as src
COPY . .

# 
FROM src as test
COPY . .
RUN yarn --pure-lockfile
RUN yarn run test

# 
FROM src as prod
ENTRYPOINT ["node_modules/.bin/nodemon"]
CMD ["server.js"]