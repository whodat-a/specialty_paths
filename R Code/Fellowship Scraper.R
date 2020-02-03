library(rvest)
library(stringr)
library(plyr)

fellowships <- read_html("http://www.nrmp.org/participating-fellowships/")

fellowship.list <- 
  fellowships %>%
    html_nodes(".individual-boxSMALL .title") %>%
    html_text()

fellowship.links <- 
  fellowships %>%
    html_nodes(".main-box a") %>%
    html_attr("href")

fellowship.db <- data.frame(fellowship.names = fellowship.list, urls = fellowship.links, stringsAsFactors = FALSE)

fellowship.tree <- list()

for(i in seq(nrow(fellowship.db))){
  residency <- 
    read_html(fellowship.db$urls[i]) %>% # load the page
    html_nodes(".match-row ul li") %>% # isolate the text
    html_text()
  res.list <- word(residency[1], 2, sep = fixed(" in ")) # grab part of sentence after 'in'
  res.list <- unlist(strsplit(res.list, split = "\\or\\s|\\,\\s")) # separate by commas and "or"
  res.list <- res.list[res.list > 1] # only elements with size > 1
  fellowship.tree[[fellowship.db$fellowship.names[i]]] <- res.list
}


fellowship.tree.df <- Reduce(rbind, Map(cbind, fellowship.tree, fellowship = names(fellowship.tree)))
colnames(fellowship.tree.df) <- c("residency", "fellowship")

write.csv(fellowship.tree.df, 'fellowships edgelist.csv', row.names = F)

