#' Search documents
#' @description search_documents() enables you to search every document containg a keyword during a specific time interval
#' @param user_key your user key generated from https://developer.meltwater.com
#' @param token your token generated from access_token()
#' @param keyword the keyword you want to explore
#' @param start_date start date, in "1900-01-01" format
#' @param end_date end date, in "1900-01-01" format
#' @param type "news_article", "social_post" or "all", defaults to "all"
#'
#' @examples
#' df <- search_documents(user_key = user_key, token = token,
#' keyword = "demoskop",
#' start_date = "2017-07-01",
#' end_date = "2017-07-13",
#' type = "news_article")
#'
#' @import dplyr, jsonlite, httr, purrr, chron

search_documents <- function(keyword, start_date, end_date, type = "news"){

  url <- paste0("https://api.meltwater.com/search/v1/documents?keyword=%22", keyword,
                "%22&start_date=", start_date, "T00:00:00Z&end_date=", end_date,
                "T12:59:59Z&type=", type, "&page_size=100")

# The GET call using httr
  resp <- GET(url = url,
    add_headers('user-key' = Sys.getenv("meltwater_key"),
                'Authorization' = Sys.getenv("meltwater_token"),
                'Accept' = "application/json"))

if(resp$status_code == 400){
  stop("Invalid request", call. = FALSE)
}

  if(resp$status_code == 403){
    stop("Invalid credentials, is your token valid?")
  }
  else{

  # Response from json -> s3
resp_json <- jsonlite::fromJSON(content(resp, "text"), simplifyVector = FALSE)

# Data.table alternative, depracated
# df <- data.frame(rbindlist(resp_json[-1])) %>% t() %>% as.data.frame()

# Turn into tidy data frame
df <- resp_json[-1] %>%
  map_df(transpose) %>%
  as.data.frame()

# Create a time variable
df$time <- substring(df$document_publish_date, 12, 19) %>% times()

# Date column to R date format
df$document_publish_date <- substring(df$document_publish_date, 1, 10) %>%
  as.Date()

# Manually unlist document key phrases and key words
df$document_key_phrases <- paste(substring(df$document_key_phrases, 7,
                                           length(df$document_key_phrases)-1),
                                 collapse = ",")
df$document_matched_keywords <- paste(substring(df$document_matched_keywords, 7,
                                                length(df$document_matched_keywords)-2),
                                 collapse = ",")

df$document_tags <- c("")
    
df$document_authors <- as.character(df$document_authors)

# Unlist all columns
df <- df %>%
  mutate_all(funs(unlist(.)))
}
return(df)
}

