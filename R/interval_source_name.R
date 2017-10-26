#' @title Get top source names for social post over a time period. Only available for social posts.
#' @description interval_source_name() generates a data frame containing the number of documents written about a keyword or search id during an interval of time
#' @param keyword the keyword you want to explore, e.g. "iphone"
#' @param search_id an ID for a search in Meltwater
#' @param start_date start date, in "1900-01-01" format
#' @param end_date end date, in "1900-01-01" format
#' @param granularity defaults to "DAY" but "HOUR", "DAY", "WEEK" and "MONTH" are available.
#'
#' @examples df <- interval_source_name(start_date = "2017-07-01",
#'  end_date = "2017-07-13", keyword = "demoskop")
#' @import dplyr httr purrr chron jsonlite tidyr
#' 
#' @export
interval_source_name <- function(start_date, end_date, keyword = NULL, search_id = NULL, granularity = "DAY"){
  if(is.null(keyword) & is.null(search_id)){
    stop("Please provide a keyword or search ID")
  }
  if(is.null(keyword)){
    url <- paste0("https://api.meltwater.com/insights/v1/intervals/count/source_name?search_id=", search_id, "&start_date=",
                  start_date, "T00%3A00%3A00Z&end_date=", end_date, "T23%3A59%3A59Z&granularity=", granularity)
  }else{
    url <- paste0("https://api.meltwater.com/insights/v1/intervals/count/source_name?keyword=", keyword, "&start_date=",
                  start_date, "T00%3A00%3A00Z&end_date=", end_date, "T23%3A59%3A59Z&granularity=", granularity)
  }
  
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
    
    # Turn into tidy data frame
    df <- resp_json[-1] %>%
      map_df(transpose) %>%
      as.data.frame()
    
    count <- flatten_list(df$count)
    
    df <- cbind(df, count) %>% select(-count) %>% rename(date = time)
    
    rm(count)
    
    df$date <- substring(df$date, 1, 10) %>%
      as.Date()
    
  }
  return(df)
}
