#' @title Request client_id and client_secret
#' @description reg_client() enables you to autheticate yourself to Meltwaters API, it generates your client_id and client_secret, you will only aquire these once so save them somewhere
#'
#' @param user_key your user key generated from https://developer.meltwater.com
#' @param username your username, most likely your e-mail
#' @param password your Meltwater password
#'
#' @import httr, jsonlite

reg_client <- function(user_key, username, password){
id_secret <- POST(url = "https://api.meltwater.com/v1/clients",
                    add_headers('user-key' = user_key),
                    authenticate(user = username, password = password))
parsed_id_secret <- jsonlite::fromJSON(content(id_secret, "text"), simplifyVector = FALSE)
return(str(parsed_id_secret))
}
