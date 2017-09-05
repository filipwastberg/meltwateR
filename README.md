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

## Save your credentials
To be able to use the functions in meltwateR you simply save your credentials in:

```{r, eval = FALSE}
Sys.setenv("meltwater_key"="your-user-key")
Sys.setenv("meltwater_client_id"="your-client-id")
Sys.setenv("meltwater_client_secret"="your-client-secret")
```

## Access token
In order to connect to Meltwaters API you need a Bearer token.

This token can be generated with the function `access_token()`. Note that the access token is only valid for an hour. The token is saved in your .Renvirontment. If the time for the token runs out, simply run the function again. 

```{r, eval = FALSE}
access_token()
```

## Let the search begin
Meltwaters API offers two search modes. First of all you specify a keyword to search for or a search ID that you have previously created. You can either search for whole documents, i.e. articles or social post, or you can just simply search for how many articles or social post were written about your keyword during, for example, the last week. 

### Search interval
`search_interval()` generates a data frame with the number of articles or social posts that have been written during a period of time. Note that Meltwater does not offer data older than 90 days.

```{r, eval = FALSE}
search_interval(keyword = "demoskop", start_date = "2017-08-04", end_date = "2017-08-10", type = "news")

        date    count     time
1 2017-08-04    86588 00:00:00
2 2017-08-05    33843 00:00:00
3 2017-08-06 11023889 00:00:00
4 2017-08-07  2854003 00:00:00
5 2017-08-08  4344250 00:00:00
6 2017-08-09  8030059 00:00:00
7 2017-08-10  5722131 00:00:00
```

### Search for documents
Where `search_interval()` generates a data frame with the number of posts written per day `search_documents()` generates a data frame with all the articles together with meta data about thouse articles, such as sentiment and the reach for that article. 

```{r, eval = FALSE}
df <- search_documents("iphone", "2017-09-03", "2017-09-05", type = "news")
```

Note that Meltwaters API allows a maximum of 100 articles to be returned. If your search exceeds 100 articles the last 100 articles will be returned. 

This is an early version of this package, please file any issue or bug you might find or contact me at filip.wastberg@demoskop.se
