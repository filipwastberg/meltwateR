#' @title Search counts of keyword during time interval
#' @description search_interval() generates a data frame containing the number of articles or social posts written about your keyword during an interval of time
#' @param keyword the keyword you want to explore, e.g. "iphone"
#' @param start_date start date, in "1900-01-01" format
#' @param end_date end date, in "1900-01-01" format
#' @param type "news_article", "social_post" or "all", defaults to "all"
#' @param granularity defaults to "DAY" but "HOUR", "DAY", "WEEK" and "MONTH" are possible.
#'
#' @examples
#' df <- search_interval(user_key = user_key, token = token,
#' keyword = "demoskop",
#' start_date = "2017-07-01",
#' end_date = "2017-07-13",
#' type = "news_article",
#' granularity = "DAY")
#' @import dplyr, jsonlite, httr, purrr, chron
#'
search_interval <- function(keyword, start_date, end_date, type = "news", granularity = "DAY"){
# manipulation of URL
  url <- paste0("https://api.meltwater.com/insights/v1/intervals/sum/source_reach?keyword=", keyword, "&start_date=",
                start_date, "T00:00:00Z&end_date=", end_date, "T12:59:59Z&type=", type,
                "&granularity=", granularity)

  # The GET call using httr
  resp <- GET(url = url,
              add_headers('user-key' = Sys.getenv("meltwater_key"),
                          'Authorization' = Sys.getenv("meltwater_token"),
                          'Accept' = "application/json"))

  if(resp$status_code == 400){
    stop("Invalid request", call. = FALSE)
  }

  if(resp$status_code == 403){
    stop("Invalid credentials")
  }
  else{

    # Response from json -> s3
    resp_json <- jsonlite::fromJSON(content(resp, "text"), simplifyVector = FALSE)

    # Turn into tidy data frame
    df <- resp_json[-1] %>%
      map_df(transpose) %>%
      as.data.frame()

    df$hms <- substring(df$time, 12, 19) %>% times()

    # substring date and transform into date
    df$time <- substring(df$time, 1, 10) %>%
      as.Date()

    colnames(df) <- c("date", "count", "time")

    df <- df %>%
      mutate_all(funs(unlist(.)))

  }
  return(df)
}
