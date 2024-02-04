FROM node:14-alpine as build
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build

# Run stage
FROM node:14-alpine
WORKDIR /app
COPY --from=build /app/ ./
EXPOSE 3000
CMD ["npm", "start"]
