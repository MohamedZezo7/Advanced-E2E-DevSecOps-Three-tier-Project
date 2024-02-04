# Stage 1: Build Stage
FROM node:14-alpine AS builder
WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install
COPY . .

# Add any additional build steps if needed

# Stage 2: Production Stage
FROM node:14-alpine
WORKDIR /usr/src/app

# Copy only the necessary artifacts from the builder stage
COPY --from=builder /usr/src/app .

# Set environment variables if needed
# ENV NODE_ENV=production

# Expose the port your app will run on
EXPOSE 3500

# Command to run your application
CMD ["node", "index.js"]












