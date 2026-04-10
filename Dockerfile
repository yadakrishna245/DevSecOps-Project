FROM node:16.17.0-alpine as builder
WORKDIR /app
COPY ./package.json .
COPY ./yarn.lock .
RUN yarn install
COPY . .
ARG TMDB_V3_API_KEY
ENV VITE_TMDB_V3_API_KEY=${TMDB_V3_API_KEY}
ENV VITE_API_ENDPOINT_URL="https://api.themoviedb.org/3"
RUN yarn build

FROM nginx:stable-alpine
WORKDIR /usr/share/nginx/html

RUN rm -rf ./*

# 🔥 ADD THIS LINE (VERY IMPORTANT)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy build files
COPY --from=builder /app/dist .

EXPOSE 80
ENTRYPOINT ["nginx", "-g", "daemon off;"]
