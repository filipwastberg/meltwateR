#' @title Access Meltwater token
#' @description access_token() generates a Bearer token, which has to be renewed every hour.
#' @param client_id your id, generated from reg_client()
#' @param client_secret your secret, generated from reg_client
#' @param user_key your user key generated from https://developer.meltwater.com
#'
#' @import httr, jsonlite

access_token <- function(client_id, client_secret, user_key){
token <- POST(url = "https://api.meltwater.com/oauth2/token",
     authenticate(user = client_id, password = client_secret),
     add_headers('user-key' = user_key,
                 'content-type' = "application/x-www-form-urlencoded"),
     body = 'grant_type=client_credentials&scope=search')

parsed_token <- jsonlite::fromJSON(content(token, "text"), simplifyVector = FALSE)

return(paste("Bearer", parsed_token$access_token))
}
