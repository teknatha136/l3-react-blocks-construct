FROM node:22-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install --ignore-scripts
COPY . .
ARG ci_build
ENV NODE_OPTIONS="--max-old-space-size=2048"
RUN mkdir -p /app/log && npm run build:${ci_build}

FROM nginx:stable-alpine
COPY --from=builder /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
