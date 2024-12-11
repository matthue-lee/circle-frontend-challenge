# Use Node.js base image
FROM node:16-slim as base

WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

RUN apt-get update -y && apt-get install -y openssl

# Install dependencies, including devDependencies (to include TypeScript)
RUN npm ci --include=dev

# Copy the rest of the application files
COPY . .
# Copy Prisma files
COPY prisma ./prisma

# Generate Prisma Client
RUN npx prisma generate

# Build the application (transpile TypeScript to JavaScript)
RUN npm run build

# Use a minimal runtime image
FROM node:16-slim as runtime

WORKDIR /app

# Copy only necessary files from the build step
COPY --from=base /app/dist ./dist
COPY --from=base /app/package*.json ./

# Install production dependencies only
RUN npm ci --omit=dev

# Start the application
CMD ["sh", "-c", "npx prisma generate && npx prisma migrate deploy && node dist/src/index.js"]
