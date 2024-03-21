#################################################
# Base image: Make project files available
# for the 2 main images below
#################################################
FROM node:20 AS base

# Set the working directory
WORKDIR /app

# Bundle app source
COPY . .

#################################################
# Production image: Built and ready to run
#################################################
FROM base AS production

ENV NODE_ENV=production
RUN npm install && npm run build

# Start the Next.js app in production mode
CMD ["npm", "run", "start"]

#################################################
# Development image: Absent the build step
#################################################
FROM base AS development

RUN apt update && apt upgrade \
  && apt install -y git \
  && apt install -y curl \
  && curl -Lo /tmp/gcm-linux_amd64.2.4.1.deb https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.4.1/gcm-linux_amd64.2.4.1.deb \
  && dpkg -i /tmp/gcm-linux_amd64.2.4.1.deb \
  && rm /tmp/gcm-linux_amd64.2.4.1.deb \
  && /usr/local/bin/git-credential-manager configure \
  && git config --global credential.credentialStore plaintext

ENV NODE_ENV=development
RUN npm install

# Start the Next.js app in development mode
CMD ["npm", "run", "dev"]
