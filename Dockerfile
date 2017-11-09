# Client App
FROM node:6-alpine as client-app
LABEL authors="John Papa"
WORKDIR /usr/src/app
COPY ["package.json", "npm-shrinkwrap.json*", "./"]
RUN npm install --silent
COPY . /usr/src/app
RUN npm run build

# Node server
FROM node:6-alpine as node-server
WORKDIR /usr/src/app
COPY ["package.json", "npm-shrinkwrap.json*", "./"]
RUN npm install --production --silent && mv node_modules ../
COPY . /usr/src/app

# Final image
FROM node:6-alpine
WORKDIR /usr/src/app
COPY --from=node-server /usr/src /usr/src
COPY --from=client-app /usr/src/app/server/www /usr/src/app/server/www
EXPOSE 3001
CMD [ "node", "index.js" ]

