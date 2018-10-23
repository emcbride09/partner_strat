install.packages("ggrepel")
require(ggrepel)
require(tidyverse)
require(googlesheets)

org_data <- gs_title("Organisation Mapping and Assessment")


#
gs_ws_ls(org_data)

org_sheet <- gs_read(ss= org_data, ws = "org_data")

org_sheet$org_tier <- as.factor(org_sheet$org_tier)
org_sheet$data_quant <- as.numeric(org_sheet$data_quant)
org_sheet$data_relevance <- as.numeric(org_sheet$data_relevance)

org_graph <- org_sheet %>% ggplot(aes(data_relevance, data_quant, label = org_name, color = org_tier)) + 
  labs(title = "EAA Partnership Organisation Map", x = "Data Relevance to EAA", y = "Data Quantity", 
       subtitle = "EAA Partnership Targets")

org_graph + geom_point(size = 3) + 
  xlim(0,10) +
  ylim(0,10) +
  geom_label_repel(nudge_x = 0.55, nudge_y = 0.2, show.legend = FALSE) +
  scale_color_brewer(palette = "Dark2", name = "Organisation Tier",
                     labels = c("Priority", "Desirable", "Secondary")) +
  theme(plot.title = element_text(family = 'Arial', 
                                        size = 16, 
                                        vjust = 0,
                                        hjust = 0,
                                        colour = 'black'),
          plot.subtitle = element_text(family = 'Arial',
                                       size = 10),
        panel.background = element_rect(fill = 'white'),
        plot.background = element_rect(fill = 'white'),
        panel.grid = element_blank(),
        legend.key = element_rect(fill = NA, size = 7, color = NA),
        legend.background = element_rect(fill = 'white'))


                     