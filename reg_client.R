## meltwateR

library(httr)

reg_client <- function(user_key, username, password){
id_secret <- POST(url = "https://api.meltwater.com/v1/clients",
                    add_headers('user-key' = user_key),
                    authenticate(user = username, password = password))
parsed_id_secret <- jsonlite::fromJSON(content(id_secret, "text"), simplifyVector = FALSE)
return(str(parsed_id_secret))
}

# Example
#reg_client(user_key = user_key,
#           username = username,
#           password = password)

# The original curl code
#curl -X POST \
#https://api.meltwater.com/v1/clients \
#--header user-key: 5c2d7ac7a8de3cc2ad6711336cb96df5 \
#--user filip.wastberg@demoskop.se:fra602nmiT

# Resulterar i 
# {"client_id":"553a4177f9d48b7a3f267a64","client_secret":"PSXZRmj5C9tfKgSP4dZ8Pj34K8fidnrrXg=="}

