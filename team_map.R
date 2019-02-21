library(googlesheets)
library(tidyverse)
library(ggrepel)

gs_auth(new_user = TRUE)

list <- gs_ls()

short <- list %>% filter(grepl('data', sheet_title))

team_data <- gs_title("data_partnerships_team")

gs_ws_ls(team_data)

team <- gs_read(ss = team_data, ws = 'dpt')

#join to world map data
world_data <- map_data('world')

world_data <- world_data %>% filter(region != 'Antarctica')

team$location <- as.factor(team$location)

team_map_data <- full_join(world_data, team, by = c('region' = 'location'))

countries <- as.data.frame(unique(world_data$region))


#aggregate data to remove duplications
#filter out anything extra
#aggregation ffunction works well here, pull labels from other data source
agg.data <- aggregate(cbind(long,lat, group) ~ team_member, data = team_map_data, mean)

#if using place names you need to filter the places you want from ones you don't see EEWG R in HDX project for that

team_map_data$team_member <- as.factor(team_map_data$team_member)

team_map <- team_map_data %>% ggplot(aes(x = long, y = lat, group = group)) + 
  geom_polygon(aes(fill = team_member), color = "grey60", size = 0.5) +
  geom_label_repel(data = agg.data, aes(long, lat, label = as.character(team_member))) +
  labs(title = 'HDX Data Partnership Team', subtitle = 'All of our superstars around the world')

team_map  + theme(panel.background = element_rect(fill = 'black'),
               plot.background = element_rect(fill = 'black'),
               panel.grid = element_blank(),
               axis.text = element_blank(),
               axis.title = element_blank(),
               plot.title = element_text(colour = 'white', family = 'Arial', size = 36),
               plot.subtitle = element_text(colour = 'white', family = 'Arial', size = 20),
               legend.background = element_blank(),
               legend.text = element_text(colour = 'white', size = '16'),
               legend.title = element_text(family = 'Arial', color = 'white', size = '20'),
               legend.justification=c(0.005, 2), legend.position=c(0,1))
