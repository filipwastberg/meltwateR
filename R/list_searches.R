#' @title Get a list of all your searches in Meltwater
#' @description list_searches() generates a data frame containing all your searches in Meltwater with Search ID
#' @param include_query include a query with information such as query type, case sensitivity etc.
#'
#' @examples
#' df <- list_searches()
#' @import dplyr httr purrr chron
#'
list_searches <- function(include_query = "false"){
  # manipulation of URL
    url <- paste0("https://api.meltwater.com/search/v1/searches?include_query=", include_query)

  
  # The GET call using httr
  resp <- GET(url = url,
              add_headers('user-key' = Sys.getenv("meltwater_key"),
                          'Authorization' = access_token(),
                          'Accept' = "application/json"))
  
  if(resp$status_code == 400){
    stop("Invalid request", call. = FALSE)
  }
  
  if(resp$status_code == 403){
    stop("Unauthorized Request, are your credentials up to date?")
  }
  
  if(resp$status_code == 422){
    stop("Unprocessable Entity, is your Search ID or keyword correct?")
  }
  if(resp$status_code == 500){
    stop("Internal Server Error")
  }
  else{
    # Response from json -> s3
    resp_json <- jsonlite::fromJSON(content(resp, "text"), simplifyVector = FALSE)
    
    if(include_query == "false"){
      df <- resp_json[-3] %>%
        map_df(transpose) %>%
        as.data.frame()  
      
    }else{
      df <- resp_json[-3] %>%
        map_df(transpose) %>%
        as.data.frame()  
      
      query_df <- flatten_list(df$query)
      
      df <- cbind(df, query_df) %>%
        select(-query)
      
      rm(query_df)
      
    }
    
    # Date column to R date format
    df$updated <- substring(df$updated, 1, 10) %>%
      as.Date()
  }
  return(df)
}

