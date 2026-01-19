# Evomics_Intro_to_R

Materials for practical "Introduction to R" tought at [Workshop on Genomics in Český Krumlov](https://evomics.org/2026-workshop-on-genomics/).

### Start
In your web browser, open RStudio by going to `<Your_IP>:8787`. 

In RStudio, open file `/home/genomics/workshop_materials/Evomics_Intro_to_R/Evomics_2025_R_ggplot.rmd`. Further instructions are in this file (or in the file [Evomics_R_ggplot.md](Evomics_R_ggplot.md) here on GitHub for better viewing.

### Using the tutorial at home
To use the tutorial at home, you need to:
1. Download and install [RStudio](https://posit.co/download/rstudio-desktop/).
2. Download this repository. You can use `git clone https://github.com/mduchoslav/Evomics_Intro_to_R` if you are on system with Git (like Linux) or download manually at least the files [Evomics_R_ggplot.rmd](Evomics_R_ggplot.rmd), [plantData.csv](plantData.csv), [info_repotted.csv](info_repotted.csv) and [XA53_experiment.txt](XA53_experiment.txt).
3. You might need to install the packages needed (you can use `install.packages("package_name")` or the RStudio menu *Tools* -> *Install Packages*).
4. In the beginning of the tutorial, you need to set the right working directory using the command `setwd("/change/to/path/of/your/folder/with/downloaded/files").

### Resources for deeper learning of R

Here we list just two resources, but many other are available online.

[fasteR: Fast Lane to Learning R!](https://github.com/matloff/fasteR) by Norm Matloff for learning base R

[R for Data Science](https://r4ds.hadley.nz/) by tidyverse authors for learning R including ggplot2 and the rest of tidyverse
