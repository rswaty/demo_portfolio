

## Some demo chart code ------

# Randy Swaty
# June 17, 2024
# Code to demo two ways to insert a chart into a Quarto file; one basic, one more complicated



## Simple bar chart -----

# code chunk set up: {r bps chart, message=FALSE, warning=FALSE, echo=FALSE, fig.width=10, fig.height=10}


# load packages
library(tidyverse)
library(scales)

# read in data; then wrangle a little to get top 10 BpSs
bps_data <- read.csv("data/bps_aoi_attributes_onf.csv")

bps_name <- bps_data %>%
  group_by(BPS_NAME) %>%
  summarize(ACRES = sum(ACRES),
            REL_PERCENT = sum(REL_PERCENT)) %>%
  arrange(desc(REL_PERCENT)) %>%
  top_n(n = 10, wt = REL_PERCENT)

# plot
bps_chart <- 
  ggplot(data = bps_name, aes(x = BPS_NAME, y = REL_PERCENT)) +
  geom_bar(stat = "identity") +
  labs(
    title = "Top 10 Biophysical Settings",
    caption = "Data from landfire.gov",
    x = "",
    y = "Percent of landscape") +
  scale_x_discrete(limits = rev(bpsname$BPS_NAME),
                   labels = function(x) str_wrap(x, width = 18)) +
  coord_flip() +
  theme_bw(base_size = 12)


bps_chart


## Chord diagram -----

# more complicated; illustrates one way to serve up an interactive chart

# how code chunk is set up {r chord, echo=FALSE, message=FALSE, warning=FALSE, include=FALSE}.  We do not want reader to see any of this :)

# load libraries (many of these you will need to install if you try this)

library(chorddiag)
library(htmlwidgets)
library(igraph)
library(readr)
library(tidygraph)
library(tidyverse)


# read in data
chord_df <- read_csv("data/bps2evt_chord_onf.csv")


#convert to matrix
matrix_df <- as.matrix(as_adjacency_matrix(as_tbl_graph(chord_df),attr = "ACRES"))

#clean up matrix (could be cleaner!I run one line then another to inspect as I go)
matrix_df = subset(matrix_df, select = -c(1:5))

matrix_df <- matrix_df[-c(6:13),]

#make a custom color pallet #eb4034 (redish) #b0af9e(grey)

# ORIGINAL
groupColors <- c( "#1d4220", # past conifer 
                 "#fc9d03", # past grassland
                 "#56bf5f", # past hardwood
                 "#397d3f", # past hardwood-conifer 
                 "#7db7c7", # past riparian 
                 "#f5e942", # present ag
                 "#1d4220", # present conifer
                 "#397d3f", # present hdw-con
                 "#b0af9e", # present developed
                 "#eb4034", # present exotics
                 "#fc9d03", # present grassland
                 "#56bf5f", # present hardwood
                 "#7db7c7", # present riparian
                 "#6e4f1e"  # present shrubland
)



#make chord diagram
chord <- chorddiag(data = matrix_df,
                 type = "bipartite",
                 groupColors = groupColors,
                 groupnamePadding = 10,
                 groupPadding = 3,
                 groupnameFontsize = 12 ,
                 showTicks = FALSE,
                 margin = 150,
                 tooltipGroupConnector = "    &#x25B6;    ",
                 chordedgeColor = "#363533"
)

chord 

#save then print to have white background
htmlwidgets::saveWidget(chord,
                        "chord.html",
                        background = "white",
                        selfcontained = TRUE
)

# then in the Quarto doc
```
<iframe src="chord.html" height="720" width="720" style="border: 1px solid #464646;" allowfullscreen allow="autoplay" data-external=".5">
  
</iframe>
  
<br>
  
```