

FROM node:18-alpine AS base
WORKDIR /app
COPY package.json .


FROM node:18-alpine AS production
WORKDIR /app


COPY --from=base /app/package.json .


COPY server.js .

EXPOSE 3000


CMD ["node", "server.js"]
