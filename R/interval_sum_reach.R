#' @title Search counts of keyword during time interval
#' @description interval_sum_reach() generates a data frame with the sum of reach over a period for a keyword
#' @param keyword the keyword you want to explore, e.g. "iphone"
#' @param search_id an ID for a search in Meltwater
#' @param start_date start date, in "1900-01-01" format
#' @param end_date end date, in "1900-01-01" format
#' @param type defaults to NULL and returns "all", can be news" or "social"
#' @param granularity defaults to "DAY" but "HOUR", "DAY", "WEEK" and "MONTH" are possible.
#'
#' @examples df <- interval_sum_reach(start_date = "2017-07-01",
#'  keyword = "demoskop", type = "news", granularity = "DAY")
#' @import dplyr httr purrr chron jsonlite tidyr
#' 
#' @export
#'
interval_sum_reach <- function(start_date, end_date, keyword = NULL, search_id = NULL, type = NULL, granularity = "DAY"){
# manipulation of URL
  if(is.null(keyword)){
    url <- paste0("https://api.meltwater.com/insights/v1/intervals/sum/source_reach?search_id=", search_id, "&start_date=",
                  start_date, "T00%3A00%3A00Z&end_date=", end_date, "T23%3A59%3A59Z&granularity=", granularity)
    
    if(!is.null(type)){
      url <- paste0(url, "&type=", type)
    }
  }else{
    url <- paste0("https://api.meltwater.com/insights/v1/intervals/sum/source_reach?keyword=", keyword, "&start_date=",
                  start_date, "T00%3A00%3A00Z&end_date=", end_date, "T23%3A59%3A59Z&granularity=", granularity)
    if(!is.null(type)){
      url <- paste0(url, "&type=", type)
    }
    
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

    df$hms <- substring(df$time, 12, 19) %>% chron::times()

    # substring date and transform into date
    df$time <- substring(df$time, 1, 10) %>%
      as.Date()

    colnames(df) <- c("date", "sum_reach", "time")
    
    df <- df[1:2]

    df <- df %>%
      mutate_all(funs(unlist(.)))

  }
  return(df)
}
