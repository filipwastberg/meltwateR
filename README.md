## Installation
Install meltwateR with package `devtools` and `install_github()`

```{r, eval = FALSE}
install_github("filipwastberg/meltwateR")
```

## Create client credentials
In order to access Meltwaters data base you need to:
1) Access your user-key
2) Create client credentials
3) Access a token to use in your searches

Your user-key is generated here: https://developer.meltwater.com

You can create your client credentiels either on the website above or with the function `reg_client()`. I recommend you use the website.

```{r, eval = FALSE}
library(meltwateR)
reg_client(user_key, username, password)
```

## Access token
In order to connect to Meltwaters API you need a token.

This token can be generated with the function `access_token()`. Note that the access token is only valid for an hour. After running the function you will have an object called token to use in the other functions. 

```{r, eval = FALSE}
access_token(client_id, client_secret, user_key)
```

## Let the search begin
Meltwaters API offers two search modes. First of all you specify a keyword to search for or a search ID that you have previously created. You can either search for whole documents, i.e. articles or social post, or you can just simply search for how many articles or social post were written about your keyword during, for example, the last week. 

### Search interval
`search_interval()` generates a data frame with the number of articles or social posts that have been written during a period of time. Note that Meltwater does not offer data older than 90 days.

```{r, eval = FALSE}
df <- search_interval(user_key = user_key, token = token,
keyword = "demoskop", start_date = "2017-07-01", end_date = "2017-07-13",
type = "news_article", granularity = "DAY")
```

### Search for documents
Where `search_interval()` generates a data frame with the number of posts written per day `search_documents()` generates a data frame with all the articles together with meta data about thouse articles, such as sentiment and the reach for that article. 

```{r, eval = FALSE}
df <- search_documents(user_key = user_key, token = token,
keyword = "demoskop", start_date = "2017-07-01", end_date = "2017-07-13",
type = "news_article")
```

Note that Meltwaters API allows a maximum of 100 articles to be returned. If your search exceeds 100 articles the last 100 articles will be returned. 

This is an early version of this package, please file any issue or bug you might find or contact me at filip.wastberg@demoskop.se
