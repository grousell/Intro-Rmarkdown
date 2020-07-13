
# Libraries ---------------------------------------------------------------

library(tidyverse)
library(scales)
library(rmarkdown)


# ggplot theme ------------------------------------------------------------

theme_update(
  plot.margin= unit(c(0.25,0.25,0.25,0.25), "cm"),                 ##requires grid package starts at top, right, bottom,left
  title = element_text (colour="black", size=15),                  ##Colour and size of chart title
  
  panel.background = element_rect(fill="NA"),                     ##Background colour of chart
  panel.border = element_blank(),                                 ##No border around chart panel
  panel.grid.major.y = element_line(colour="grey90"),             ##Major y-axis gridline colour
  panel.grid.minor.y = element_line(colour="NA"),                 ##Minor y-axis gridline colour
  panel.grid.major.x = element_line(colour="NA"),             ##Major y-axis gridline colour
  panel.grid.minor.x = element_line(colour="NA"),                 ##Minor y-axis gridline colour
  
  axis.text.y = element_text (colour="black", size=10, hjust=1),  ##Colour and size of y-axis text
  axis.title.y = element_text (colour="black", size=12, angle=90), ##Colour, size and angle of y axis title
  
  axis.text.x = element_text (colour="black", size=8,angle=0),   ##Colour, size, angle of x-axis text
  axis.title.x = element_text (colour="black", size=12),          ##Colour and size of x-axis title
  
  
  legend.text = element_text (colour="black", size = 12),          ##Colour and size of legend text
  legend.position = ("bottom"),                                   ##Position of legend
  legend.title = element_text(colour = "black"),                                  ##Removes title from legend box
  
  plot.title = element_text(hjust = 0.5),
  plot.subtitle = element_text(hjust = 0.5)
  )
  

# Load Data ---------------------------------------------------------------

df <- read_csv ("data/sample_data.csv")

factor_levels <- c ("1 - Not at All", 
                    "2",
                    "3", 
                    "4", 
                    "5 - Significantly")

df <- df %>% 
  mutate_at(vars (starts_with("session")),
            ~(parse_factor(., levels = factor_levels)
            )
  )


# Summary Table

summary_table <- df %>% 
  pivot_longer(cols = starts_with("session"),
               names_to = "question",
               values_to = "response") %>%
  group_by (school, question) %>% 
  count (response) %>% 
  mutate (Percent = n / sum(n))
  

# Loop --------------------------------------------------------------------


for (sch in unique(df$school)) {
  rmarkdown::render("Advanced_PDF_Example.Rmd",
                    output_file =  paste(sch, "_report.pdf", sep=''), 
                    output_dir = './reports/')
}


#remove temporary files
files.tex <- list.files(pattern = "\\.tex$")
if(file.exists(files.tex)) file.remove(files.tex)

files.log <- list.files(pattern = "\\.log$")
if(file.exists(files.log)) file.remove(files.log)

files.aux <- list.files(pattern = "\\.aux$")
if(file.exists(files.aux)) file.remove(files.aux)
