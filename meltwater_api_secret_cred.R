## Meltwater API credentials

{"client_id":"553a4177f9d48b7a3f267a64","client_secret":"PSXZRmj5C9tfKgSP4dZ8Pj34K8fidnrrXg=="}

curl -X POST \
https://api.meltwater.com/oauth2/token \
--user '553a4177f9d48b7a3f267a64:PSXZRmj5C9tfKgSP4dZ8Pj34K8fidnrrXg==' \
--header 'content-type: application/x-www-form-urlencoded' \
--header 'user-key: 6b5ca32b8f8d13304350e27de5f71bd2' \
--data 'grant_type=client_credentials&scope=search'

{"access_token":"nH2ujcZhxVojB5BVasX6fvktWHVIn8vu1M5OBMHhw0E.tX1h9cXcY-0v3T4eJD8UcBV9bIl9-6HAnIqw6Lnr2Xo","expires_in":3599,"scope":"search","token_type":"bearer"}