# Use an official Node.js runtime as a base image
FROM node:20

# Set the working directory
WORKDIR /app

# Install app dependencies
COPY package.json package-lock.json ./
RUN npm install

# Bundle app source
COPY . .

# Start the Next.js app
CMD ["npm", "run", "dev"]
