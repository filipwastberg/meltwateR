#authenticate 
library(httr)

access_token <- function(client_id, client_secret, user_key){
token <- POST(url = "https://api.meltwater.com/oauth2/token",
     authenticate(user = client_id, password = client_secret),
     add_headers('user-key' = user_key,
                 'content-type' = "application/x-www-form-urlencoded"),
     body = 'grant_type=client_credentials&scope=search')

parsed_token <- jsonlite::fromJSON(content(token, "text"), simplifyVector = FALSE)

return(paste("Bearer", parsed_token$access_token))
}

# Example
#token <- access_token(client_id = client_id,
#     client_secret = client_secret,
#     user_key = user_key)

#curl -X POST \
#--user '<client_id>:<client_secret>' \
#--url https://api.meltwater.com/oauth2/token \
#--header 'content-type: application/x-www-form-urlencoded' \
#--header 'user-key: <user_key>' \
#--data 'grant_type=client_credentials&scope=search'

# curl code (invalid credentials)
#curl -X POST \
##https://api.meltwater.com/oauth2/token \
#--user '553a417sdghahadg3f267a64:PSXZRmj5C9tfsdfsdfasgashK8fidnrrXg==' \
#--header 'content-type: application/x-www-form-urlencoded' \
#--header 'user-key: 6b5ca32b8f8xxs3fdsfds450e27de5f71bd2' \
#--data 'grant_type=client_credentials&scope=search'
