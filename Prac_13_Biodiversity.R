#### Install libraries ----
install.packages('readr')
install.packages('dplyr')
install.packages('ggplot2')
install.packages('sf')
install.packages('effects')
install.packages('stargazer')

#### Load libraries ----
library(readr)
library(dplyr)
library(ggplot2)
library(sf)
library(effects)
library(stargazer)

#### Load in data ----
# POSA diversity data
posa_rich <- read_csv('data/posa_richness.csv')

# QDS and covariates
qds_cov <- read_sf('data/grass_qds_cov.shp')

# Map of SA
sa <- read_sf('data/SA_border/SA_border.shp')

#### Explore the data ----
#### Plants of SA data ----

# Take a look at the data
posa_rich

# What is the species found in most Quarter Degree Square (QDS)?
posa_rich %>% count(Taxon) %>% arrange(-n)

# How many different plant families are there?
n_distinct(posa_rich$Family)

# What different functional types are there?
posa_rich %>% distinct(func_type) -> functional_types
print(functional_types, n = 29)

# What is the most common functional type?
posa_rich %>% count(func_type) %>% arrange(-n)

# Is the richness data normally distributed?
hist(posa_rich$spp_rich)
hist(log(posa_rich$spp_rich))
hist(log(posa_rich$func_diversity))

#### Spatial data (QDS) ----
qds_cov

# Where are our grids inside SA?
ggplot() +
  geom_sf(data = sa) +
  geom_sf(data = qds_cov)

# What are the labels of our grids?
ggplot() +
  geom_sf(data = qds_cov) +
  geom_sf_label(data = qds_cov, aes(label = QDS), size = 1)

# NPP
ggplot() +
  geom_sf(data = qds_cov, aes(fill = NPP), lwd = 0) +
  scale_fill_gradient2(low = 'white', high = 'darkgreen',
                       name = 'NPP\n(kg C/m2/yr)') +
  labs(x = 'Longitude', y = 'Latitude') +
  theme_bw() 

ggplot() +
  geom_sf(data = qds_cov, aes(fill = NPP_var), lwd = 0) +
  scale_fill_gradient2(low = 'white', high = 'darkblue',
                       name = 'NPP variability\n(kg C/m2/yr)') +
  labs(x = 'Longitude', y = 'Latitude') +
  theme_bw()
  
#### Clean the data and join it together ----
# only select one row for each QDS
posa_rich %>% distinct(QDS, .keep_all = TRUE) -> posa_rich

# select the columns we want
posa_rich %>% select(QDS, spp_rich, func_diversity, phylog_diversity) -> posa_rich

# join the two datasets together
# reminder of each dataset
head(posa_rich)
head(qds_cov)

# join the twon datasets based on the shared column 'QDS'
qds_cov %>% left_join(posa_rich, by = 'QDS') %>% select(QDS:NPP_var, spp_rich:phylog_diversity, geometry) %>% filter(!is.na(spp_rich)) -> joined_data

#### Analyse the data ----

# 1) Species richness vs. Functional diversity
ggplot(data = joined_data, aes(x = spp_rich, y = func_diversity)) +
  geom_point() +
  geom_smooth(se = F) +
  labs(x = 'Species Richness', y = 'Functional Diversity') +
  theme_bw()

# 2) Species richness vs. Phylogenetic diversity
ggplot(data = joined_data, aes(x = spp_rich, y = phylog_diversity)) +
  geom_point() +
  geom_smooth(se = F) +
  labs(x = 'Species Richness', y = 'Phylogenetic Diversity') +
  theme_bw()

# 3) Species richness vs. NPP
ggplot(data = joined_data, aes(x = spp_rich, y = NPP)) +
  geom_point() +
  geom_smooth(se = F) +
  labs(x = 'Species Richness', y = 'NPP (kg C/m2/yr)') +
  theme_bw()

# 4) Functional diversity vs. NPP
ggplot(data = joined_data, aes(x = func_diversity, y = NPP)) +
  geom_point() +
  geom_smooth(se = F) +
  labs(x = 'Functional Diversity', y = 'NPP (kg C/m2/yr)') +
  theme_bw()

# 5) Species richness vs. NPP variability
ggplot(data = joined_data, aes(x = spp_rich, y = NPP_var)) +
  geom_point() +
  geom_smooth(se = F) +
  labs(x = 'Species Richness', y = 'NPP variability (kg C/m2/yr)') +
  theme_bw()

#### run a linear model ----
# 1) What is the statistical relationship between NPP and species richness? 
model1 <- lm(NPP ~ log(spp_rich), data = joined_data)
# look at regression coefficients
summary(model1)

# Plot the predicted relationship between NPP and species richness
plot(allEffects(model1), ylim = c(0,1)) 

# 2) What is the statistical relationship between NPP and functional diversity? 
model2 <- lm(NPP ~ log(func_diversity), data = joined_data)
# look at regression coefficients
summary(model2)

# Plot the predicted relationship between NPP and functional diversity
plot(allEffects(model2), ylim = c(0,1))

#### Summaries of linear models ----
# This function provides a neat summary of the regressions for both models
stargazer(model1, model2, type = 'text')


