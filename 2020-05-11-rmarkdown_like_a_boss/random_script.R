# Get an overview of the data
gaminder_data <- gapminder::gapminder
summary(gaminder_data)

# Plot the variables of interest
library(ggplot2)
ggplot(gaminder_data, 
       aes(year, pop)) + 
  geom_point() +
  labs(title = "Example output")

# Run a linear model
model1 <- lm(pop ~ year, data = gaminder_data)
library(broom)

# Inspect the model summary table
tidy(model1)
