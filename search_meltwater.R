## Get

# Curl code
#curl -X GET 'https://api.meltwater.com/v1/searches/documents?keyword=iphone&start_date=2017-03-01T08%3A15%3A30-05%3A00&end_date=2017-03-03T08%3A15%3A30-05%3A00&type=news_article&result_type=list' \
#--header 'user-key: <user_key>' \
#--header 'Authorization: Bearer <access_token>' \
#--header 'Accept: application/json'

library(httr)
library(data.table)
library(dplyr)
library(purrr)

search_meltwater <- function(url, user_key, token){
# The GET call using httr
  resp <- GET(url = url,
    add_headers('user-key' = user_key,
                'Authorization' = token,
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

# Data.table alternative, depracated
# df <- data.frame(rbindlist(resp_json[-1])) %>% t() %>% as.data.frame()

# Turn into tidy data frame
df <- resp_json[-1] %>% 
  map_df(transpose) %>%
  as.data.frame() 

# Date column to R date format
df$document_publish_date <- substring(df$document_publish_date, 1, 10) %>%
  as.Date()

# Manually unlist document key phrases and key words
df$document_key_phrases <- paste(substring(df$document_key_phrases, 6,
                                           length(df$document_key_phrases)-1),
                                 collapse = ",")
df$document_matched_keywords <- paste(substring(df$document_matched_keywords, 6,
                                                length(df$document_matched_keywords)-1),
                                 collapse = ",")

df$document_tags <- c("")

# Unlist all columns 
df <- df %>%
  mutate_all(funs(unlist(.)))
}
return(df)
}

# Example
# demoskop <- search_meltwater(url = "https://api.meltwater.com/v1/searches/documents?keyword=demoskop&start_date=2017-05-03T00%3A00%3A00.592Z&end_date=2017-07-03T00%3A00%3A00.592Z&type=news_article&page_size=100",
#                           user_key = "6b5ca32b8f8d13304350e27de5f71bd2",
#                           token = token)

# Example 
#demoskop %>%
#  filter(source_country_code == "se") %>%
#  group_by(document_publish_date, document_sentiment) %>%
#  summarise(sum = sum(source_reach)) %>%
#  ggplot() +
#  geom_line(aes(x = document_publish_date, y = sum,
#                color = document_sentiment)) +
#  labs(title = "Demoskop in the news by sentiment", y = "Reach", x = "Date") +
#  scale_y_continuous(labels = scales::format_format(big.mark = " ",
#                                                    decimal.mark = ",
#                                                    ", scientific = FALSE))

