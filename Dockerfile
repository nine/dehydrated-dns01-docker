FROM python:3.8-slim
ARG CONTACT_EMAIL
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
         dehydrated \
    && rm -rf /var/lib/apt/lists \
    && pip install dns-lexicon[full]
ADD conf.d /etc/dehydrated/conf.d/
ADD dehydrated.default.sh /etc/dehydrated/ 
RUN echo "CONTACT_EMAIL=\"$CONTACT_EMAIL\"" > /etc/dehydrated/conf.d/10_contact_email.sh

#CMD ["/usr/bin/dehydrated", "--cron", "--challenge", "dns-01"]


