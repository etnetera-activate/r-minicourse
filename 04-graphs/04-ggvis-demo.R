install.packages("ggvis")
library(ggvis)
library(dplyr)

tbl_df(mtcars)

mtcars %>% ggvis(x = ~wt, y= ~mpg, fill = ~factor(cyl), size := 10) %>% layer_points()

mtcars %>% 
  ggvis(~wt) %>% 
  layer_histograms(width =  input_slider(0, 2, step = 0.10, label = "width"),
                   center = input_slider(0, 2, step = 0.05, label = "center"))


keys_s <- left_right(10, 1000, step = 50)
mtcars %>% ggvis(~wt, ~mpg, size := keys_s, opacity := 0.5) %>% layer_points()


mtcars %>% ggvis(~wt, ~mpg) %>% 
  layer_points() %>% 
  add_tooltip(function(df) df$wt)

t <- seq(0, 2 * pi, length = 100)
df <- data.frame(x = sin(t), y = cos(t))
df %>% ggvis(~x, ~y) %>% layer_paths()


library(ggplot2)
ggplot(Minard.cities, aes(x = long, y = lat)) +
  geom_path(
    aes(size = survivors, colour = direction, group = group),
    data = Minard.troops
  ) +
  geom_point() +
  geom_text(aes(label = city), hjust=0, vjust=1, size=4)
