## Installation
Install meltwateR with package `devtools` and `install_github()`

```{r, eval = FALSE}
install_github("filipwastberg/meltwateR")
```

## Create client credentials
In order to access Meltwaters data base you need to:
1) Access your user-key
2) Create client credentials

Your user-key is generated here: https://developer.meltwater.com

You can create your client credentiels either on the website above or with the function `reg_client()`. I recommend you use the website.

## Save your credentials
To be able to use the functions in the package you simply save your credentials in the Sys.environment.

```{r, eval = FALSE}
Sys.setenv("meltwater_key"="your-user-key")
Sys.setenv("meltwater_client_id"="your-client-id")
Sys.setenv("meltwater_client_secret"="your-client-secret")
```

## Access token
In order to connect to Meltwaters API you need a token. The token is generated when running any of the functions. If you want to access your token you can: 
```{r, eval = FALSE}
access_token()
```

## Let the search begin
Meltwaters API offers a number of searches. You can search media monitoring data for a specific keyword or for a Search ID created in Meltwater.

### Interval document count
`interval_document_count()` generates a data frame with the number of articles or social posts that have been written during a period of time.

```{r, eval = FALSE}
interval_count_df <- interval_document_count(start_date = "2017-10-01",
                                             end_date = "2017-10-25",  
                                             keyword = "demoskop")
```

### Search for documents
Where `interval_document_count()` generates a data frame with the number of posts written `search_documents()` generates a data frame with all the articles together with meta data about these articles, such as sentiment and the reach for that article. Furthermore, since version 0.2 all the keywords and the authors of the document is available in the data frame.

```{r, eval = FALSE}
df <- search_documents("iphone", "2017-09-03", "2017-09-05", type = "news", page_size = "130")
```

Note that Meltwaters API allows a maximum of 1000 articles to be returned. If your search exceeds 100 articles the last 100 articles will be returned. 

### Interval sum reach
With `interval_sum_reach()` you can access the reach of the documents written about a certain keyword or Search ID.

```{r, eval = FALSE}
df <- interval_sum_reach(start_date = "2017-07-01", search_id = "123456")
```

### Interval source name
`interval_source_name()` get top source names for social post over a time period. Only available for social posts.

```{r, eval = FALSE}
df <- interval_source_name(start_date = "2017-07-01", end_date = "2017-07-13", keyword = "demoskop")
```

### Interval document authors
`interval_document_authors()` lists the top document authors of social posts over a time period. Only available for social posts.

```{r, eval = FALSE}
df <- interval_document_authors(keyword = "demoskop", start_date = "2017-07-01", end_date = "2017-07-13", type = "news_article")
```

### List searches
`list_searches()` enables you to list all your searches, this is where you most easily find your Search ID.

```{r, eval = FALSE}
df <- list_searches()
```

This is an early version of this package, please file any issue or bug you might find or contact me at filip.wastberg@demoskop.se
