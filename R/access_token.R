#' @title Access Meltwater token
#' @description access_token() generates a Bearer token that is saved to your .Renvironment file. It is valid for 1 hour. If you run out of time, just run the function again.
#' @param client_id your id, generated from reg_client()
#' @param client_secret your secret, generated from reg_client
#' @param user_key your user key generated from https://developer.meltwater.com
#'
#' @import httr, jsonlite

access_token <- function(){
token <- POST(url = "https://api.meltwater.com/oauth2/access_token",
     authenticate(user = Sys.getenv("meltwater_client_id"), password = Sys.getenv("meltwater_client_secret")),
     add_headers('user-key' =  Sys.getenv("meltwater_key"),
                 'content-type' = "application/x-www-form-urlencoded"),
     body = 'grant_type=client_credentials&scope=search')

parsed_token <- jsonlite::fromJSON(content(token, "text"), simplifyVector = FALSE)

token <- paste("Bearer", parsed_token$access_token)

return(Sys.setenv("meltwater_token" = token))
}
