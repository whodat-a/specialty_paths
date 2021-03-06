library(chorddiag)
library(igraph)
library(jsonlite)

# setwd("~/Box Sync/Projects/specialty_paths/R Code/")
# fellowships.el <- read.csv("fellowships edgelist.csv", stringsAsFactors = F)
abms.el <- read.csv("abms.csv", stringsAsFactors = F)
freida.el <- read.csv("freida.csv", stringsAsFactors = F)

fellowships.el <- merge(abms.el, freida.el,
                        all.x = TRUE, all.y = TRUE)
write.csv(fellowships.el, file = "fellowships merged edgelist.csv", quote = FALSE,
          row.names = FALSE)

fellowships.el <- read.csv("fellowships-merged-edgelist.csv", stringsAsFactors = FALSE)

# fellowships.el <- fellowships.el[-c(109, 49, 61,
#                                     64, 65, 72, 114,
#                                     116, )]

g <- as.matrix(get.adjacency(graph.data.frame(fellowships.el)))
json_mat <- toJSON(g)


write(json_mat, file = "matrix.json")
name <- unlist(dimnames(g)[1])
color <- c("#82a24d",
           "#834cd0",
           "#65d053",
           "#8f37b4",
           "#67b021",
           "#466cf0",
           "#b2c22f",
           "#344fc3",
           "#90cf54",
           "#6750c9",
           "#38a435",
           "#c45ad7",
           "#44cb6c",
           "#cc2da0",
           "#67a93c",
           "#c375f5",
           "#9fc348",
           "#2580fe",
           "#d5b731",
           "#6864d9",
           "#819f26",
           "#867af4",
           "#ec9926",
           "#4883ef",
           "#d9a734",
           "#9d63d9",
           "#2d7c26",
           "#ad38a6",
           "#38cc94",
           "#f34292",
           "#3eaa61",
           "#e85ec1",
           "#8ac66a",
           "#7a45a7",
           "#a4b34c",
           "#5c51b1",
           "#c4b64c",
           "#3360bd",
           "#eb7230",
           "#4b96eb",
           "#e25528",
           "#34b9e1",
           "#ca2d22",
           "#49d2d5",
           "#de3448",
           "#2bbcce",
           "#e52f66",
           "#62ceb2",
           "#d2237b",
           "#51903f",
           "#ed7fe4",
           "#708524",
           "#c57eea",
           "#4c6a18",
           "#a458bc",
           "#87c57d",
           "#a93686",
           "#72bf89",
           "#c64e9f",
           "#2f8152",
           "#eb5e9b",
           "#4f9966",
           "#b379d8",
           "#959035",
           "#8c7ce2",
           "#c38024",
           "#6781dd",
           "#dd802f",
           "#53a4e5",
           "#be3e20",
           "#72bae8",
           "#a02c17",
           "#3fadaf",
           "#f16354",
           "#47a586",
           "#dc4664",
           "#2c928b",
           "#ab2635",
           "#6b9d5a",
           "#b765b8",
           "#b2bc6b",
           "#8f418d",
           "#a48020",
           "#af8ee6",
           "#a0580f",
           "#716fbb",
           "#e0a352",
           "#634d93",
           "#bc581d",
           "#4484b6",
           "#f1945f",
           "#4763a0",
           "#f58568",
           "#277257",
           "#db97ed",
           "#426c32",
           "#ec92d5",
           "#71661a",
           "#8564b4",
           "#d0b673",
           "#a297e1",
           "#895c1d",
           "#8799d8",
           "#9e471f",
           "#d2aae9",
           "#738c4e",
           "#b13670",
           "#b1bc7e",
           "#c66bae",
           "#91995e",
           "#ba8dd4",
           "#af8e48",
           "#8b71b1",
           "#efb07a",
           "#cb86c8",
           "#726c37",
           "#e77199",
           "#d5a877",
           "#8b4a75",
           "#dd9a6c",
           "#af75a1",
           "#c96940",
           "#eb92ba",
           "#85522e",
           "#cb6a98",
           "#b77848",
           "#b43456",
           "#9f7349",
           "#e76681",
           "#9b442f",
           "#e79aa2",
           "#cb4c47",
           "#8b4a5f",
           "#eb957f",
           "#9e445c",
           "#c06e51",
           "#8f494f",
           "#e76870",
           "#9d5141",
           "#e78085",
           "#b54a4e",
           "#bb6f6b",
           "#ce6552",
           "#c4616a")
nodes_and_colors <- cbind(name, color)

write.csv(nodes_and_colors, file="teams.csv", quote = FALSE,
          row.names = FALSE)

dimnames(adj_matrix) <- list(Residency = dimnames(adj_matrix)[1],
                             Fellowship = dimnames(adj_matrix)[2])
chorddiag(g, groupnamePadding = 25)

