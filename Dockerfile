FROM node:16.20.2 AS builder
WORKDIR /app
COPY . ./
RUN rm -rf node modules and package-lock.json
RUN npm install --legacy-peer-deps
RUN npm rebuild node-sass
ARG VALUES="development"
RUN if [ "$VALUES" = "development" ] ; then npm run buildDevelop ;elif [ "$VALUES" = "uat" ] ; then npm run buildStaging ; fi
# For the production environment COPY to Nginx webserver document root
FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
