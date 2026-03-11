# Multi-stage Dockerfile for Hello World app

# Stage 1: Base/Dependencies
FROM node:18-alpine AS base
WORKDIR /app
COPY package.json .

# Stage 2: Production
FROM node:18-alpine AS production
WORKDIR /app

# Copy package.json from base stage
COPY --from=base /app/package.json .

# Copy application code
COPY server.js .

# Expose port
EXPOSE 3000

# Start the application
CMD ["node", "server.js"]
