FROM nginx
COPY public/ /usr/share/nginx/html/

RUN ls -la /usr/share/nginx/html/*