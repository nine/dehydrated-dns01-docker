```
export AUTH_USERNAME="your_user"
export AUTH_TOKEN="your_pass"
```


```
lexicon hetzner create evk.services TXT --name="_acme-challenge.gitlab" --content="challenge token" --auth-account konsoleh --auth-username $AUTH_USERNAME --auth-password $AUTH_TOKEN  
lexicon hetzner list   evk.services TXT --name="_acme-challenge.gitlab" --content="challenge token" --auth-account konsoleh --auth-username $AUTH_USERNAME --auth-password $AUTH_TOKEN 
lexicon hetzner delete evk.services TXT --name="_acme-challenge.gitlab" --content="challenge token" --auth-account konsoleh --auth-username $AUTH_USERNAME --auth-password $AUTH_TOKEN 
```


```
docker build -t dehydrated --build-arg CONTACT_EMAIL="webmaster@evk.biz" .
```


```
docker run \ 
    -e "PROVIDER=hetzner" \
    -e "PROVIDER_ACCOUNT=konsoleh" \
    -e "PROVIDER_PASSWORD=$AUTH_TOKEN" \
    -e "PROVIDER_USERNAME=$AUTH_USERNAME" \
    -e "PROVIDER_UPDATE_DELAY=30" \
    -v ${PWD}/domains.txt:/etc/dehydrated/domains.txt \
    -v ${PWD}/docker-dehydrated/dehydrated:/var/lib/dehydrated \
    -t dehydrated /usr/bin/dehydrated --cron --challenge dns-01
```

