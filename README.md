# dehydrated.io docker image for letsencypt.org ACME dns-01 challenge

## Provider auth-token

Add generated auth-token, e.g. from https://dns.hetzner.com
```
export AUTH_TOKEN="your_token"
```

Test the communication with following commands: 
```
lexicon hetzner create evk.services TXT --name="_acme-challenge.gitlab" --content="challenge token" --auth-token $AUTH_TOKEN  
lexicon hetzner list   evk.services TXT --name="_acme-challenge.gitlab" --content="challenge token" --auth-token $AUTH_TOKEN 
lexicon hetzner delete evk.services TXT --name="_acme-challenge.gitlab" --content="challenge token" --auth-token $AUTH_TOKEN 
```

## Docker container

### Build the container

Build the container locally:
```
docker build -t dehydrated --build-arg CONTACT_EMAIL="it.admin@yourcompany.biz" .
```

Alternatively push the image to your docker registry:
```
docker build -t your-docker-registry.services:4567/path/to/dehydrated-dns01-docker --build-arg CONTACT_EMAIL="it.admin@yourcompany.biz" .
docker push your-docker-registry.services:4567/path/to/dehydrated-dns01-docker
```

### Deploy the container


Setup
```
mkdir /var/lib/dehydrated/
mkdir /etc/dehydrated/
echo "your-domain.org" >> /etc/dehydrated/domains.txt
echo "export AUTH_TOKEN='your_token'" > /etc/dehydrated/auth-token
```

Get the docker image:
```
docker pull your-docker-registry.services:4567/path/to/dehydrated-dns01-docker
```


Register at letsencrypt.org and accept the terms and conditions:
```
docker run \
    --rm \
    -v /etc/dehydrated/domains.txt:/etc/dehydrated/domains.txt \
    -v /var/lib/dehydrated:/var/lib/dehydrated \
    -t dehydrated \
    /usr/bin/dehydrated --register --accept-terms
```

Refresh certificates
```
source /etc/dehydrated/auth-token
docker run \ 
    -e "PROVIDER=hetzner" \
    -e "PROVIDER_AUTH_TOKEN=$AUTH_TOKEN" \
    -e "PROVIDER_UPDATE_DELAY=240" \
    --rm \
    -v /etc/dehydrated/domains.txt:/etc/dehydrated/domains.txt \
    -v /var/lib/dehydrated:/var/lib/dehydrated \
    -t dehydrated \
    /usr/bin/dehydrated --cron --challenge dns-01
```

