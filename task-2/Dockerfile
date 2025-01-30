# Use the official Node.js image as the base image
FROM node:12.22.12

# Set the working directory in the container
WORKDIR /app

# Copy the package.json and package-lock.json files to the container
COPY package*.json ./

# Install dependencies inside the container
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose port 3000 (or whatever your app uses)
EXPOSE 3000

# Start the app
CMD ["npm", "start"]

