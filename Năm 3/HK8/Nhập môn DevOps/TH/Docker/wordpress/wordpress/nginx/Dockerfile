
ARG VERSION_IMAGE
FROM nginx:${VERSION_IMAGE}-alpine
COPY ./index.html /usr/share/nginx/html/
COPY ./conf/nginx.conf /etc/nginx/conf.d/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]