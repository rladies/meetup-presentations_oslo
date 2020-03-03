library(tidyverse)
library(tidymodels)
library(corrplot)

###########################
#     The tidymodels way
###########################

# Naming convention:
# 
# _rec for a recipe
# 
# _mod for a parsnip model specification
#
# _wfl for a workflow
# 
# _fit for a fitted model
# 
# _tune for a tuning object
# 
# _res for a general result


# Split from rsample
set.seed(4595)
data_split <- initial_split(mtcars, strata = "mpg")
mtcars_train <- training(data_split) 
mtcars_test  <- testing(data_split)
nrow(mtcars_train)/nrow(mtcars)

## EDA
mtcars_train %>% 
  select_if(is_numeric) %>% 
  pivot_longer(everything(),
               names_to = "names", 
               values_to = "values") %>% 
  ggplot(aes(values)) +
  geom_histogram() + 
  facet_wrap(~names, scales="free") 

mtcars_train %>% 
  select_if(is_numeric) %>% 
  cor() %>% 
  corrplot(method = "color")

## Feature Engineering with recipes
mtcars_rec <- recipe(mpg ~ ., 
                     data = mtcars_train) %>%
  step_normalize(all_predictors()) %>% 
  step_interact(terms = ~ wt:am) %>% 
  prep(verbose = TRUE) 

# The magic of Juice() and bake()
train <- juice(mtcars_rec) 
test  <- bake(mtcars_rec, mtcars_test)

# Select model  
mtcars_mod <- linear_reg() %>% 
  set_engine("lm") 

# Summarise the previous steps in the workflow
mtcars_wfl <- workflow() %>% 
  add_recipe(mtcars_rec) %>% 
  add_model(mtcars_mod)
mtcars_wfl

# Train the model and set model performance metrics
perf_metrics <- metric_set(rmse, rsq)
mtcars_fit <- fit(mtcars_wfl, train)

# Predict on the test set and get performance
predict(mtcars_fit, test) %>% 
  bind_cols(test) %>% 
  dplyr::select(mpg, .pred) %>% 
  perf_metrics(truth = mpg, estimate = .pred)




