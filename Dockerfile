# docker image build -f Dockerfile -t benpelletier/reverse_proxy .

FROM nginx

RUN apt-get update
RUN apt-get -y install certbot python-certbot-nginx
