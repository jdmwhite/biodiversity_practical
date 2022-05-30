# Practical 13: Biodiversity and Productivity
### APES2039A
Dr. Joseph White
03/06/2022

## Background

In this practical we will explore the relationships between different types of biodiversity (species richness, functional diversity, phylogenetic diversity) and productivity (Net Primary Productivity).

We will make use of two different datasets. 

1) Plants of South Africa (POSA) specimen and habit dataset
2) MODIS Terra satellite's derived annual Net Primary Productivity (NPP) at 500m pixel resolution.

The [POSA specimen and habit dataset](http://posa.sanbi.org/) is an extensive collection of plant samples with locations from all of South Africa collected over more than 200 years. These include herbarium records and verified observations amongst others. 

The [MODIS NPP dataset](https://lpdaac.usgs.gov/products/mod17a3hgfv006/) provides annual derived productivity values across the globe. The dataset represent the average NPP values from 2001-2021.

The data for both POSA and NPP is subsetted to only include values for the grassland biome of South Africa. These are linked to a location across the country in the form of a grid system referred to as a Quarter Degree Square (QDS). Each grid cell is roughly 30 x 30 km in size.

## If you would like to follow along and run the code yourself

Go to [R Studio Cloud](https://rstudio.cloud/). Either **Sign Up** or as you have already run a practical here before, **Log In** to your account. Once you have logged in, click on **New Project** in the top right corner. Select **New Project from Git Repository**. Copy and paste this link into the open space: https://github.com/jdmwhite/practical_13_biodiversity

Wait for the project to deploy (this may take a couple of minutes). Once it has opened, click on the `Prac_13_Biodiversity.R` file. You can now run the code, either using (Cntrl + ENTER) or click the **Run** button in the top middle of your screen.

Make sure to **LOG OUT** of your R Studio Cloud session when you are finished using the platform. You are granted 25 free hours per month. But these hours will be depleted quickly if you don't log out!

#### Full markdown

Find the full practical 13 markdown [HERE](https://github.com/jdmwhite/practical_13_biodiversity/blob/main/Prac_13_Biodiversity.md)
