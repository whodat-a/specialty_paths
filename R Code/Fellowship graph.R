library(rCharts)
library(igraph)

setwd("~/Box Sync/Projects/specialty_paths/R Code/")
fellowships.el <- read.csv("fellowships edgelist.csv", stringsAsFactors = F)

g <- graph.data.frame(fellowships.el)

V(g)$weight = 0
#now for all vertexes with out degree = 0
V(g)[degree(g,mode="out")==0]$weight <- runif(n=length(V(g)[degree(g,mode="out")==0]),
                                              min=0,max=100)
#the lowest level of the heirarchy is defined with a random weight
#with the lowest level defined we should now be able to sum the vertex weights
#to define the edge weight
#E(g2)$weight = 0.1 #define all weights small to visually see as we build sankey
E(g)[to(V(g)$weight>0)]$weight <- V(g)[V(g)$weight>0]$weight
#and to find the neighbors to the 0 out degree vertex
#we could do V(g2)[nei(degree(g2,mode="out")==0)]
#we have everything we need to build the rest by summing
#these edge weights if there are edges still undefined
#so set up a loop to run until all edges have a defined weight
while(max(is.na(E(g)$weight))) {
  #get.data.frame gives us from, to, and weight
  #we will get this to make an easier reference later
  df <- get.data.frame(g)
  #now go through each edge and find the sum of all its subedges
  #we need to check to make sure out degree of its "to" vertex is not 0
  #or we will get 0 since there are no edges for vertex with out degree 0
  for (i in 1:nrow(df)) {
    x = df[i,]
    #sum only those with out degree > 0 or sum will be 0
    if(max(df$from==x$to)) {
      E(g)[from(x$from) & to(x$to)]$weight = sum(E(g)[from(x$to)]$weight)
    }
  }
}

edgelist <- get.data.frame(g) #this will give us a data frame with from,to,weight
colnames(edgelist) <- c("source","target","value")
#make character rather than numeric for proper functioning
edgelist$source <- as.character(edgelist$source)
edgelist$target <- as.character(edgelist$target)


sankeyPlot <- rCharts$new()
sankeyPlot$setLib('./rCharts_d3_sankey-gh-pages/')
sankeyPlot$setTemplate(script = "./rCharts_d3_sankey-gh-pages/layouts/chart.html")

sankeyPlot$set(
  data = edgelist,
  nodeWidth = 15,
  nodePadding = 10,
  layout = 32,
  width = 960,
  height = 760
)

# sankeyPlot$print(chartId = 'sankey1')
# sankeyPlot

sankeyPlot$save('Fellowships Sankey.html', standalone = FALSE)
sankeyPlot$publish('Specialty Paths', host = 'gist')
