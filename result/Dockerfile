FROM node:18-slim@sha256:f9ab18e354e6855ae56ef2b290dd225c1e51a564f87584b9bd21dd651838830e

# add curl for healthcheck; upgrade picks up Debian security fixes
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends curl tini && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/app

# have nodemon available for local dev use (file watching)
RUN npm install -g nodemon

COPY package*.json ./

RUN npm ci && \
 npm cache clean --force && \
 mv /usr/local/app/node_modules /node_modules

# npm is only needed to build; remove it so its bundled dependencies
# (including a vulnerable tar) are not shipped in the final image
RUN rm -rf /usr/local/lib/node_modules/npm /usr/local/bin/npm /usr/local/bin/npx

COPY --chown=node:node . .

ENV PORT=80
EXPOSE 80

# Run as the unprivileged user that ships with the node image
USER node

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["node", "server.js"]
