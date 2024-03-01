FROM node:18.17.1-alpine AS builder

WORKDIR /usr/app

COPY ./ ./
COPY prisma ./prisma

RUN npm install
RUN npm run build

COPY prisma .next/standalone 

FROM node:18.17.1-alpine AS runner 

WORKDIR /usr/app

RUN apk add openssl zlib libgcc

RUN npm install -g prisma

COPY --from=builder /usr/app/.next/standalone /usr/app
COPY --from=builder /usr/app/.next/static /usr/app/.next/static

ENV DATABASE_URL="postgresql://todo:TODOPASSWORD@postgres:5432/todo?schema=public" 
ENV NODE_ENV="production"

# WORKDIR .next/standalone

# RUN npm run migrate deploy

# RUN node server.js

EXPOSE 3000

CMD ["node", "server.js"]
