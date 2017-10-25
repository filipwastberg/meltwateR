#' Search documents
#' @description search_documents() enables you to search every document containg a keyword during a specific time interval
#' @param keyword the keyword you want to explore
#' @param search_id a search ID
#' @param start_date start date, in "1900-01-01" format
#' @param end_date end date, in "1900-01-01" format
#' @param type "news" or "social"
#'
#' @examples df <- search_documents(start_date = "2017-07-01", end_date = "2017-07-13",keyword = "demoskop", type = "news")
#' @import dplyr httr purrr chron

search_documents <- function(start_date, end_date, keyword = NULL, search_id = NULL, type = "news", page_size = "30"){

  if(is.null(keyword)){
    url <- paste0("https://api.meltwater.com/search/v1/documents?search_id=", search_id,
                  "&start_date=", start_date, "T00%3A00%3A00Z&end_date=", end_date,
                  "T23%3A59%3A59Z&type=", type, "&page_size=", page_size)
    
  }else{
    url <- paste0("https://api.meltwater.com/search/v1/documents?keyword=", keyword,
                  "&start_date=", start_date, "T00%3A00%3A00Z&end_date=", end_date,
                  "T23%3A59%3A59Z&type=", type, "&page_size=", page_size)
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
df$time <- substring(df$document_publish_date, 12, 19) %>% chron::times()

# Date column to R date format
df$document_publish_date <- substring(df$document_publish_date, 1, 10) %>%
  as.Date()

document_key_phrases <- df$document_key_phrases %>%
  flatten_list()

colnames(document_key_phrases) <- paste0("key_phrase", colnames(document_key_phrases))
#
document_matched_keywords <- df$document_matched_keywords %>%
  flatten_list()

colnames(document_matched_keywords) <- paste0("keyword", colnames(keyword))
#

df$document_tags <- c("")
#
document_authors <- df$document_authors %>%
  flatten_list()

colnames(document_authors) <- paste0("document_author", colnames(document_authors))

df <- cbind(df, document_key_phrases, document_matched_keywords, document_authors) %>%
  select(-document_key_phrases, -document_matched_keywords, -document_authors)

rm(document_key_phrases, document_matched_keywords, document_authors)
# Manually unlist document key phrases and key words
#df$document_key_phrases <- paste(substring(df$document_key_phrases, 7,
#                                           length(df$document_key_phrases)-1),
#                                 collapse = ",")
#df$document_matched_keywords <- paste(substring(df$document_matched_keywords, 7,
#                                                length(df$document_matched_keywords)-2),
#                                 collapse = ",")#
#
#df$document_authors <- as.character(df$document_authors)
#
# Unlist all columns
#df <- df %>%
#  mutate_all(funs(unlist(.)))
}
return(df)
}

