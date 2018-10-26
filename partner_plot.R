install.packages("ggrepel")
require(ggrepel)
require(tidyverse)
require(googlesheets)
devtools::install_github("hrbrmstr/ggalt")
library(ggplot2)
library(ggalt)
library(ggfortify)

org_data <- gs_title("Organisation Mapping and Assessment")


#
gs_ws_ls(org_data)

org_sheet <- gs_read(ss= org_data, ws = "org_data")

org_sheet$org_tier <- as.factor(org_sheet$org_tier)
org_sheet$data_quant <- as.numeric(org_sheet$data_quant)
org_sheet$data_relevance <- as.numeric(org_sheet$data_relevance)

org_graph <- org_sheet %>% ggplot(aes(data_relevance, data_availability, label = org_name, color = org_tier)) + 
  labs(title = "EAA Partnership Organisation Map", x = "Data Relevance to EAA", y = "Data Availability", 
       subtitle = "EAA 2nd Year Partnership Targets")

org_graph + geom_point(size = 3) + 
  xlim(0,10) +
  ylim(0,10) +
  geom_label_repel(nudge_x = 0.55, nudge_y = 0.2, show.legend = FALSE,
                   label.size = .5,
                   box.padding = 0.5,
                   force = 2) +
  geom_encircle() +
  scale_color_brewer(palette = "Dark2", name = "Organisation Tier",
                     labels = c("Priority", "Desirable", "Secondary")) +
  theme(plot.title = element_text(family = 'Arial', 
                                        size = 30, 
                                        vjust = 0,
                                        hjust = 0,
                                        colour = 'black'),
          plot.subtitle = element_text(family = 'Arial',
                                       size = 16),
        panel.background = element_rect(fill = 'white'),
        plot.background = element_rect(fill = 'white'),
        panel.grid = element_blank(),
        legend.key = element_rect(fill = NA, size = 7, color = NA),
        legend.background = element_rect(fill = 'white'),
        legend.text = element_text(size = 14),
        legend.title = element_text(size = 14))

ggsave("partnership_orgs.png", plot = last_plot(), width = 250, height = 150, units = "mm", dpi = 400)




#--------------------
#-Barplot
#-------------------
bar <- org_sheet %>% ggplot(aes(org_tier, data_relevance, colour = org_tier, label = org_name)) +
  labs(title = "EAA Partnership Organisation Map", x = "Org Tier", y = "Data Relevance", 
       subtitle = "EAA Data Partnership Targets") +
  geom_point(size = 20, alpha = 0.3)+
  geom_label_repel(nudge_x = 0.25, nudge_y = 0.2, show.legend = FALSE,
                    label.size = .5,
                    box.padding = 0.5,
                    force = 2) +
                    scale_color_brewer(palette = "Spectral", name = "Organisation Tier",
                                        labels = c("Priority", "Desirable", "Secondary", "Invalid")) +
                     theme(plot.title = element_text(family = 'Arial', 
                                                     size = 30, 
                                                     vjust = 0,
                                                     hjust = 0,
                                                     colour = 'black'),
                           plot.subtitle = element_text(family = 'Arial',
                                                        size = 16),
                           panel.background = element_rect(fill = 'white'),
                           plot.background = element_rect(fill = 'white'),
                           panel.grid = element_blank(),
                           legend.key = element_rect(fill = NA, size = 7, color = NA),
                           legend.background = element_rect(fill = 'white'),
                           legend.text = element_text(size = 14),
                           legend.title = element_text(size = 14))


ggsave("partnership_orgs_label_col.png", plot = last_plot(), width = 250, height = 150, units = "mm", dpi = 400)

bar

