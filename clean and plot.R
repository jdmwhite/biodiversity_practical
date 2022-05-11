library(tidyverse)
library(sf)
library(patchwork)

# posa_dat <- readxl::read_xlsx('data/2022-02-17_211701717-BRAHMSOnlineData.xlsx')
# beepr::beep(4)
# names(posa_dat)
# 
# unique(posa_dat$MajorRegion)
# length(unique(posa_dat$Taxon))
# 
# head(posa_dat)
# 
# posa_dat %>% filter(CountryName == 'South Africa') -> posa_sa
# unique(posa_sa$MajorRegion)
# length(unique(posa_sa$Taxon))
# 
# posa_sa %>% filter(MajorRegion %in% c('Mpumulanga', 'Eastern Cape', 'KwaZulu-Natal', 'Limpopo', 'North West', 'Gauteng', 'Free State')) -> posa_prov
# length(unique(posa_prov$Taxon))
# 
# head(posa_prov)
# length(unique(posa_prov$QDS))
# 
# posa_prov %>% drop_na(QDS) -> posa_prov
# 
# posa_prov$Taxon <- ifelse(is.na(word(posa_prov$Taxon, 1, 2)), posa_prov$Taxon, word(posa_prov$Taxon, 1, 2))
# length(unique(posa_prov$Taxon))
# 
# write_csv(posa_prov, 'output/posa_clean/posa_clean.csv')

posa_prov <- read_csv('output/posa_clean/posa_clean.csv')

#### load in grassland qds
grass_qds <- read_sf('data/QDS_grid_grass/grass_qds.shp')

####
posa_prov %>% filter(QDS %in% grass_qds$QDGC) -> posa_grass
length(unique(posa_grass$Taxon))


# Keep only one entry per species per pentad
posa_grass %>% group_by(QDS, Taxon) %>% filter(row_number()==1) -> posa_unique_spp_qds
length(unique(posa_unique_spp_qds$Taxon))

posa_unique_spp_qds %>% group_by(QDS) %>% summarise(spp_rich = n()) -> grass_spp_rich
head(grass_spp_rich)

grass_qds %>% rename(QDS = QDGC) %>% left_join(grass_spp_rich, by = 'QDS') %>% select(OBJECTID, QDS, spp_rich, geometry) -> grass_qds_spp_rich

write_sf(grass_qds_spp_rich, 'output/spp_rich/spp_rich.shp')

saveRDS(grass_qds_spp_rich, 'output/spp_rich/spp_rich.RData')

grass_qds_spp_rich %>% filter(spp_rich > 25) -> spp_rich_sf

ggplot(spp_rich_sf) +
  geom_sf(aes(fill = spp_rich))

#### read in MAP
qds_map <- read_csv('data/QDS_grid_map_EE/grass_qds_map.csv')
names(qds_map)
qds_map %>% select(QDGC, mean) %>% rename(MAP = mean, QDS = QDGC) -> qds_map_clean 
spp_rich_sf %>% left_join(qds_map_clean, by = 'QDS') %>% select(OBJECTID, QDS, spp_rich, MAP, geometry) -> spp_rich_sf_dat

#### read in top het
qds_top_het <- read_csv('data/QDS_grid_top_het_EE/grass_qds_top_het.csv')
names(qds_top_het)
qds_top_het %>% select(QDGC, stdDev) %>% rename(AHI = stdDev, QDS = QDGC) -> qds_top_het_clean 
spp_rich_sf_dat %>% left_join(qds_top_het_clean, by = 'QDS') %>% select(OBJECTID, QDS, spp_rich, MAP, AHI, geometry) -> spp_rich_sf_dat

#### plots

ggplot(spp_rich_sf_dat) +
  geom_sf(aes(fill = AHI))

ggplot(spp_rich_sf_dat) +
  geom_sf(aes(fill = MAP))

ggplot(spp_rich_sf_dat) +
  geom_sf(aes(fill = spp_rich))

ggplot(spp_rich_sf_dat) +
  geom_point(aes(x = MAP, y = AHI))

ggplot(spp_rich_sf_dat) +
  geom_point(aes(x = log(MAP), y = log(spp_rich))) +
  geom_smooth(aes(x = log(MAP), y = log(spp_rich)))


ggplot(spp_rich_sf_dat) +
  geom_point(aes(x = log(AHI), y = log(spp_rich))) +
  geom_smooth(aes(x = log(AHI), y = log(spp_rich)))

####
lm1 <- lm(spp_rich ~ AHI + MAP, data = spp_rich_sf_dat)
summary(lm1)

lm2 <- lm(log(spp_rich) ~ log(AHI) + log(MAP), data = spp_rich_sf_dat)
summary(lm2)

library(effects)
plot(allEffects(lm1))
plot(allEffects(lm2))
