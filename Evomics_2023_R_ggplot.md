### 1 Introduction

Welcome to the `R` and `ggplot2` session. The purpose of this file is to guide you through the exercises.
In this session, we will use an R Markdown file. R Markdown documents are good for keeping the R code, plots, and descriptions (structured text) in one place. It enables you to make nice reports from the data that can be exported as html, pdf, etc. You can find more information on R Markdown [here](https://rmarkdown.rstudio.com/lesson-1.html) and a cheatcheet for R Markdown [here](https://www.rstudio.com/wp-content/uploads/2015/02/rmarkdown-cheatsheet.pdf).

We will use the `wget` command to download the R Markdown file from the github repository. When you open the RStudio window (`<Your_IP>:8787`), navigate to the terminal tab. The terminal here is similar to the one in guacamole. You can start by navigating to the following folder:

`cd /home/genomics/Desktop/workshop_materials/r_ggplot2`

Here we can use the `wget` command to download our file from the github repository with the following command:

```{r}
wget https://raw.githubusercontent.com/janina-rinke/Teaching/main/Evomics_2023_R_ggplot.Rmd
```

Now, use `ls` to list all files in the directory. You should see some data files as well as the R Markdown file you just downloaded. Now using the Files tab on the bottom right of the screen, navigate to `/home/genomics/Desktop/workshop_materials/r_ggplot2` and double click on the `Evomics_2023_R_ggplot.Rmd` file to open it. 

#### Some general useful information:
If you want to insert a new code chunk, you can do it with `ctrl + alt + i` (Mac: `opt + cmd + i`).
Pressing `ctrl + enter` (Mac: `cmd + enter`) sends the line of code where the cursor is (or the selected code) to the console and runs it. You can run a whole chunk by pressing the green triangle on the right side.

```{r setup, include=FALSE}
# Define the global chunk options
knitr::opts_chunk$set(echo = TRUE, warning=FALSE, message=FALSE)
```

### 2  Load all libraries and set working directory
Load all the packages you need using the syntax from the slides.
The code is included below. 
```{r libraries}
# In case that you need to install a package before loading it, you can simply use the command install.packages("package_name")
library(ggplot2)
library(data.table)
library(dplyr)
library(tidyr)
library(purrr)
library(ape)
library(tidyverse)
library(stringr)
```

You can check which packages are already installed with the command below. 
In case that you need a new package, you could get it from [CRAN](https://cran.r-project.org), [Bioconductor](https://bioconductor.org/install/) or look for the respective GitHub repository.
```{r list libraries, eval=FALSE}
# If you would like to list your already installed packages
library()

# Check your current R version and packages
sessionInfo()
```

You can set a working folder in R. It is the default folder where you read and write files. We will set it to the `r_ggplot2` folder where our training data can be found. However, you can read and write files from/to other directories if you provide the right path.
```{r}
# Check the current working folder
getwd()
# Set the working folder
setwd("/home/genomics/workshop_materials/r_ggplot2")
```


### 3 Loading and checking your data 

#### Dataset description

This dataset comes from Milos's experiment with *Arabidopsis thaliana* plants. Three genotypes of plants were used for the experiment - **wt (wild type)** and ***psbo1cr*** and ***psbo2cr*** mutants. The mutants have non-functional *psbO1* or *psbO2* genes, encoding slightly different paralogs of the PsbO protein. PsbO is a subunit of the photosystem II, one of the main components of photosynthetic apparatus in a chloroplast. Plants completely without a PsbO protein (double mutants) would die, however, the single mutants are able to survive and can be used to study the differences between PsbO1 and PsbO2 proteins.

The purpose of the experiment was to see whether the mutations give the plants some advantages or disadvantages under drought (water stress) conditions or salt stress conditions. The plants were cultivated for several weeks under normal condition (control), drought stress (less watering) and salt stress (watering with NaCl solution). At the end of the experiment, the chlorophyll fluorescence was measured with a chlorophyll fluorescence imaging device, giving us area of the leaf rosette and *Fv/Fm* (denoted by the QY_max column of the dataset below).

#### Loading the dataset
Load the dataset and take a look at it:

```{r Load data}
#Import the data and assign it the name "plantData" using <-
plantData <- read.csv("~/workshop_materials/r_ggplot2/plantData.csv")
```

With the above command you have loaded your dataset into R and can start working on it!

Some explanations:

* Everything that is after `#` is regarded as comment and not code.
* `plantData` is a name of the new object.
* `read.csv` is a function that we used to read a comma-separated file ending with `.csv`.
* In the brackets `()` after the function name are the arguments to the function (now we have only the `file` argument, if there would be more, you would separate them with comma `,`). It is not needed to name the arguments if they are in the right order (you can use only `plantData <- read.csv("plantData.csv")` or provide the full path to the dataset (`plantData <- read.csv("~/workshop_materials/r_ggplot2/plantData.csv")`, depending on where you have set your working directory before (`set_wd`).
* `<-` is used to assign the output of the function to the `plantData` object.

Now we do some check ups on our dataset. You do not need to run these commands but they are very useful to get familiar with a dataset.

The first commands are good for big datasets. As our dataset is quite small, you can also view the entire dataset in the console by just running the name of the dataset.
```{r check your data, eval=FALSE}
# Print the first six rows of the dataset
head(plantData)

# Summary of the dataset
summary(plantData)

# What type of data do I have?
class(plantData)

# Column names of the dataset
colnames(plantData)

# Count the number of rows in your dataset
nrow(plantData)

# Printing whole dataset in the console (usable for small datasets)
plantData

# look at a selection of columns
# This command shows the first 5 rows of the first and the third column
plantData[1:5, c(1, 3)]
# c() function combines several values in one object (vector in R terminology)
# 1:5 makes vector of values 1, 2, 3, 4, 5
# the square brackets are used for subsetting of dataframe or matrix in form [row, columns]

# Viewing the dataset in separate window
View(plantData)
```

The `class()` command tells you what type of data object you are dealing with. In this case, we have a `data.frame` object.
You can read more about the different data types and data objects in R [here](https://rpubs.com/Thinklabz/data_types_and_objects).

#### Column description
The column names in this dataset are mostly self-explanatory.

* `condition` defines whether the plant was cultivated under control conditions (**c**), salt stress (**s**) or drought stress (**d**).
* `plant_id` is the ID of the particular plant.
* `genotype` denotes the genotype of the particular plant.
* `time` is a measurement of time in minutes (time since the start of all measurements). It could be useful to check whether or not the measurements were influenced by the time duration the plants were standing by the machine and waiting for the measurement.
* `size_mm2` is the area of the leaf rosette from the top view.
* `QY_max` is a maximum quantum yield of photosystem II, a term *Fv/Fm* is also frequently used for this variable. It is the most important variable that we measured, giving us some measure of how well the photosystem II works. The value is mostly around 0.83 for healthy plants. Unhealthy plants have lower values.
* Columns `NPQ_L1` to `NPQ_L4` are measurements of non-photochemical quenching in different time points after providing actinic light to the plant. We will use them later. Non-photochemical quenching is a process of safe dissipation of excitation energy to heat in order to protect the photosynthetic machinery in the case that there is more light than the photosynthetic apparatus is able to use.
As chlorophyll fluorescence quenching analysis is not easy to explain, we will not go into details now. However, you can read e.g. [this article](https://doi.org/10.1093/jexbot/51.345.659) if you are interested in that.

#### Load additional dataset for repotting of plants
We have a list of the plants that were repotted during the experiment. The info about repotting can be found in a separate file. We would like to add that info in case repotting influenced the results of this experiment. 

**Exercise 1:** Load the `info_repotted.csv` dataset.

First, use the function `read.csv()` to read the data from file `"~/workshop_materials/r_ggplot2/info_repotted.csv"` in an object called `df`. Then you can look at the data using some of the functions used above.

```{r load data 2}

```

*Several tips:*

* *Use the Tab completion as in the Unix terminal. It works both for file paths, object names and function names.*
* *F1 will bring help for the function where the cursor is.*

If you succeeded, you can see that the list in the file is not in a very useful format. We first need to split the column `info` into two columns. Then we can intersect the two dataframes based on the column `plant_id` (thus adding the term "repotted" to the corresponding plants). For similar tasks like extracting something from longer strings, **regular expressions** are often very useful, so it is well worth to learn them.

#### Manipulate data with `dplyr` or Base R
We will show you different possibilities to manipulate & filter your data. For every single step that you would like to perform on your data, there are several methods existing in R. We will present the `dplyr/tidyr` package and the `Base R` syntax here, but in the end you should find the method which is most suitable for you. 

**dplyr/tidyr** 
The `dplyr` package uses a similar syntax to Unix, the `%>%` symbol in `dplyr` simply represents the `|` (pipe) symbol in Unix. Find a cheat sheet [here](https://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf)

**Base R** 
The base R language doesn't use this, an input for base R should always be an argument in brackets `(x = input)`.
The dollar sign `$` can be used to access a column in data.frame by its name. Here we will use `df$info` to access the column named `info` in the data.frame named `info`. Similarly, you can use `plantData$plant_id` to access the `plant_id` column of `plantData` data.frame.

```{r split columns, merge datasets}
# Split columns

## Possibility 1: use "separate" function from the tidyr package
df2 <- df %>% 
  tidyr::separate(col = 1, into = c("plant_id", "info"), sep = "_")

## Possibility 2: use sub from base R and regular expressions to exchange part of the line for nothing
df.2b1 <- sub(pattern = "_.*$", replacement = "", x = df$info) 
# exchange the part after underscore for nothing ("")
df.2b2 <- sub(pattern = "^.*_", replacement = "", x = df$info) 
# exchange the part before underscore for nothing ("")
df.2b <- data.frame(plant_id = df.2b1, info = df.2b2) # put the two vectors to data.frame
# Regular expression explanation:
# _ means literally _
# . means any character (number/ alphabet/ etc.)
# * means that the preceding character is used 0 or more times
# $ means the end of the line
# ^ means the beginning of the line
# So the first regular expression ("_.*$") means that the sub function should search for underscore followed by any character that is there 0 or more times, which should be followed by the end of the line.


# Intersect both datasets to add repotting info based on plant_id
## Possibility 1: use merge from base R
merging_a <- merge(plantData, df.2b, by="plant_id", all=TRUE)

## Possibility 2: use the dplyr package
merging_b <- plantData %>% 
  dplyr::left_join(df.2b, by=c("plant_id"))

# We will continue with the merging_b dataframe, so we will rename it back to plantData (note that this overwrites the original plantData variable, which is fine in our case, but if you wanted to keep your older dataframe, you can assign it to a unique name.)

plantData <- merging_b
```


#### Clean-up
We will clean-up our dataset before we create some plots.
First, we will re-name the columns `NPQ_L1`, `NPQ_L2`, `NPQ_L3` and `NPQ_L4` into `NPQ_t1`, `NPQ_t2`, `NPQ_t3` and `NPQ_t4` because they represent timepoints of measurements.
Here is the code how to do it for `NPQ_L1` and `NPQ_L2` column. 
```{r rename first two columns}
#Rename columns
#the pattern for dplyr is rename(new_col_name=old_col_name)
#All your changes will not be overwritten unless you assign it a name with <-
plantData <- plantData %>%
  dplyr::rename(NPQ_t1 = NPQ_L1, NPQ_t2 = NPQ_L2)
```



**Exercise 2:** Rename columns `NPQ_L3` and `NPQ_L4` into `NPQ_t3` and `NPQ_t4`.
```{r}

```

Now we will add a column which explains the condition better (c -> control, d -> drought, s -> salt). We will name the new column `condition_info`.
```{r}
# Create a new column condition_info
plantData <- plantData %>%
  dplyr::mutate(condition_info = case_when(
    (condition == "c") ~ "Control",
    (condition == "d") ~ "Drought",
    (condition == "s") ~ "Salt"
    ))

# Move the new condition_info column next to the old condition column (new columns are added to the far right side of the df by default)
plantData <- plantData %>% 
  dplyr::relocate(condition_info, .after = condition)
```

After that, we will remove plants that have died during the experiment. These plants have *NA* values in columns `size_mm2` and `QY_max`. The NPQ values were not measured for all plants, and we are not going to plot those columns yet, so it is fine for now that there are some *NA* values there.

```{r Clean your data}
# Remove all NA values from size_mm2 & QY_max column, as this indicates that plants died during the experiment and we do not have data for them
pD_clean <- plantData %>%
  filter(!is.na(size_mm2), !is.na(QY_max))
```


**Exercise 3:** Check how many lines we have removed. 

Hint: Use the `nrow()` function or `dim()` function on the original `plantData` data.frame and on the new `pD_clean` data.frame.

```{r}

```

**Exercise 4:** Filter the `plantData` dataset so that you will only keep the plants that have died in a new dataframe. Make sure to assign it a new name, so you do not overwrite your original dataset which we will use for plotting in the next section.
```{r}

```

**Congrats!** You are now good to go to create some nice plots with your `pD_clean` dataset! :) 

### 4 Creating plots with `ggplot2`
There are at least three primary graphics programs available within the R environment. A package for **base R graphics** is installed by default and provides a simple mechanism to quickly create graphs. **lattice** is another graphics package that attempts to improve on base R graphics by providing better defaults and the ability to easily display multivariate relationships. In particular, the package supports the creation of trellis graphs - graphs that display a variable or the relationship between variables, conditioned on one or more other variables. Finally, **ggplot2** is a graphics program based on the grammar of graphics ideology, and will be the primary focus of this course due to the extensive documentation and resources available for it.

The syntax for a basic plot using **ggplot2** starts with the `ggplot()` function and we specify the required data (`pD_clean`) and variables to be plotted as shown below.
The geometric layer elements are added on with a `+` followed by a specific `geom_*()` function.
Learn more about geoms by running `help.search()` or `??geom_` below to get a list of available geoms and to familiarize yourself with the help documentation.
Use `geom_point()` to display the scatter plot. Run `help(geom_point)` to check out it's help documentation.

#### 4.1 Plot one genotype first
Start with making a basic boxplot of just the wt plants.

**Exercise 5:** Make a new dataframe called `pD_clean_wt` that will contain only the plants with genotype "wt".

Hint: Use the function `filter` from the package `dplyr`. As an argument for the `filter` function you should use `genotype == "wt"`. We use the double equal sign `==`, because the algorithm is going through each row of the dataframe and checking whether the `genotype` is `wt` or something else, returning TRUE or FALSE. Single equal sign `=` is used for assigning values to arguments.

We will use some of the "geoms" (geometric objects) introduced earlier to make our plots today. While there are many possible geoms possible [list of geoms](https://ggplot2.tidyverse.org/reference/index.html#section-layer-geoms), we will focus on the following geoms in this session:

* `geom_boxplot()` - A classic box and whiskers plot   
* `geom_point()` - A plot with data points (like a typical scatterplot, but it can also plot a numeric variable against a categorical variable)
* `geom_jitter()` - Similar to `geom_point()` but it adds some jitter to the points in case they're overlapping (more applicable when plotting a numeric variable with a categorical variable)
* `geom_smooth()` - Typically used as an additional layer to the scatterplot to help identify trends or patterns in the data. 


```{r}

```

Now make the boxplot.

The main arguments `ggplot` needs are the dataframe and what variables in the dataframe need to be plotted. The dataframe is simply provided to the `data` argument. Information on what is plotted is provided using the `aes` (aesthetic mappings) function. This allows us to tell `ggplot` what variables we want to plot (that is, which columns of our dataframe should be on the x and y axes).
```{r plotting graphs - p0, p1}
# Creating the background of ggplots
p0 <- ggplot(data = pD_clean_wt, aes(x=condition_info, y=QY_max))
p0

# Given this background, we can now add a boxplot "layer" to the background. ggplot is modular, so we can sequentially add layers to it. 

# Basic boxplot of condition_info with QY_max
p1 <- ggplot(data = pD_clean_wt, aes(x=condition_info, y=QY_max)) +
  geom_boxplot()
p1

# Fun fact- you can also make the p1 plot using the code p0 + geom_boxplot() 
```
You see that you can create an object with the output from the `ggplot()` function. When you run the name of the object (`p1` in this case), the plot will show.

*Comment on biology: The result is little bit puzzling, as the stressed plants under drought conditions and salt stress conditions have higher values of QY_max. However, the differences are very small.*

**Exercise 6:** Make a similar boxplot that will show size of the plants (`size_mm2`) instead of QY_max.

```{r}

```

Now we will make a stripplot (single-axis scatter plot) to have a better sense of the real data.
```{r plotting graphs - p3}
# Basic scatterplot with size_mm2
p3 <- ggplot(pD_clean_wt, aes(x=condition_info, y=size_mm2)) + 
  geom_point()
p3
```

If we have multiple values (or data points) several times, we cannot see them. Thus, it is better make the points "jitter" a bit (compare p3 above and p3a below for clarity on "jitter"). In `ggplot`, this can be done using the function `geom_jitter()`. The `width` argument within `geom_jitter` defines how scattered the points are (in our case, it will scatter the points horizontally). You can try to omit the width argument, which will default to a value `0.4`, according to "help", but as you'll notice, the points from the categories on the x-axis end up being too close to each other to distinguish which category they are from.
```{r plotting graphs - p3a}
p3a <- ggplot(pD_clean_wt, aes(x=condition_info, y=size_mm2)) + 
  geom_jitter(width = 0.1)
p3a
```

**Exercise 7:** Make the same stripplot for the genotype *psbo1cr*, showing `QY_max` values for different conditions.

Hint: You should first filter the dataframe called `pD_clean` to get only the plants of the right `genotype`. Then, make the plot.
```{r}

```

*Comment on biology: You can see that the QY_max values for psbo1cr are lower than for the wt, but they do not differ much for the different conditions.*

Compare the code for the boxplots and strip plots. The first line is the same for both types of plots, and then we can add either boxplots or points or jitter points as layers, highlighting the modular nature of `ggplot`.


Now we will plot the correlation of `size_mm2` vs `QY_max` (size is dependant on QY_max).
```{r}
# Plot correlation as scatterplot
p5 <- ggplot(pD_clean_wt, aes(x=QY_max, y=size_mm2)) + 
  geom_point()
p5

# Add a regression line with standard error and a title to the plot
p6 <- ggplot(pD_clean_wt, aes(x=QY_max, y=size_mm2)) + 
  geom_point() + 
  geom_smooth(method = lm) + 
  ggtitle("QY_max vs size_mm2 scatterplot for wt genotype")
p6

# We can colour the points according to condition
p6a <- ggplot(pD_clean_wt, aes(x=QY_max, y=size_mm2)) + 
  geom_point(aes(colour = condition_info)) + 
  geom_smooth(method = lm) +
  ggtitle("QY_max vs size_mm2 scatterplot for wt genotype")
p6a
```

*Comment on biology: As before, this is again a bit puzzling. We would expect rather positive correlation than negative. The cause is that the stressed wt plants had slightly higher QY_max, but they were smaller. However, the differences in QY_max are very small.*

**Exercise 8:** Make similar plot for control conditions and all genotypes.

Hint: You should first filter the dataframe called `pD_clean` to get only the plants of the right `condition_info`. Then, make the plot.

```{r}

```

If you succeeded to make the plot, you can see that in this case, there is a positive relationship between `QY_max` and `size_mm2`. The *psbo1cr* plants are smaller and have lower `QY_max` values compared to other genotypes.


#### 4.2 Use `for` loops to make several plots

Often it is useful to make several similar plots for either various variables or various subsets of the data. The `for` loop can be used for that. The `for` loop cycles through a list of values (`vector` in R terminology), using one by one as an input or parameter or whatever you want.

We will use a `for` loop to make the same plot for each genotype. We need to go back to our cleaned dataframe `pD_clean` and subset it in each cycle for the different genotypes.

```{r introducing for loops}
# We can grab the entire genotype column from the pD_clean dataframe, and then use the unique function for the individual genotypes.
genotype_vector <- unique(pD_clean$genotype)
# Check the unique genotype values
genotype_vector

# Using a for loop we can iterate through each genotype in the genotype vector and generate the corresponding plot 
# The basic structure of a for loop is - for (item in list_of_items) {execute this command}

# Let's start with a for loop that will simply (iterate through a list of words), and {print} each word.
for (item in c("my", "potato", "fell", "in", "my", "lemonade")) {
  print(item)
}


# Using a similar logic, we can generate a plot for each of the 3 genotypes in genotype vector. 
# So we will (iterate through the genotype vector) and then {create a dataframe for that vector like we did for the wt condition earlier in plot p1, and then generate a plot for that dataframe and print it}
for (iterated_genotype in genotype_vector) {
  # Subset the dataframe to only have the iterated genotype in for loop
  pD_clean_gt <- pD_clean %>%
    filter(genotype == iterated_genotype)
  
  # generate a strip plot for that genotype
  p_temp <- ggplot(pD_clean_gt, aes(x=condition_info, y=QY_max)) + 
  geom_jitter(width = 0.1) +
  ggtitle(iterated_genotype)
  
  print(p_temp)

}
```
Three plots, each for one genotype, should be generated. You can view them using arrows in the Plots window.
You can export all the plots to e.g. a pdf file. This can be achieved by enclosing the plotting function between the function `pdf()`, which opens the connection to a file, and `dev.off()`, which closes the connection.

```{r use for loops}
# We can grab the entire genotype column from the pD_clean dataframe, and then use the unique function for the individual genotypes.
genotype_vector <- unique(pD_clean$genotype)
# Check the unique genotype values
genotype_vector

# Open connection to pdf
pdf(file = "striplots_genotypes.pdf", onefile = T) # Parameter onefile = T is there to make one file with multiple pages, instead of several files with one plot in each.

# Using a for loop we can iterate through each genotype in the genotype vector and generate the corresponding plot 
for (iterated_genotype in genotype_vector) {
  # Subset the dataframe to only have the iterated genotype in for loop
  pD_clean_gt <- pD_clean %>%
    filter(genotype == iterated_genotype)
  
  # generate a strip plot for that genotype
  p_temp <- ggplot(pD_clean_gt, aes(x=condition_info, y=QY_max)) + 
  geom_jitter(width = 0.1) +
  ggtitle(iterated_genotype)
  
  print(p_temp)
}
# Close the connection to pdf
dev.off()
```

The pdf file should appear in your working directory. You can check that with a function `list.files()`, that will return the content of your working directory by default. You can also open it through the Guacamole desktop. If you need to know where your working directory is, you can use function `getwd()`.
```{r}
list.files()
getwd()
```

**Exercise 9:** Make strip plots of `QY_max`, one for each condition, that will show the differences between genotypes. You can either export them to pdf or just show them in the Plots window.

```{r}

```

**Extra exercise (if you have time):** Using two `for` loops (one inside the other), try to make three plots as before for the `QY_max` variable followed by three plots for the `size_mm2` variable.

Hint: Enclose the previously used `for` loop inside another `for` loop that will cycle through the two variables.

```{r} 

```


#### 4.3 Modify your graph aesthetics
We will now make our box plot a bit fancier. Although the defaults often work well, you can modify almost everything within the `ggplot2` package.

Here you can see how to modify various things in the plot.

```{r modifyPlots}
# Original box plot of QY_max by condition_info
p1 <- ggplot(pD_clean_wt, aes(x=condition_info, y=QY_max)) +
  geom_boxplot()
p1

# Now let's get fancy with this plot. We'll start with our p1 plot and sequentially add layers to it.

p1_fancy <- ggplot(pD_clean_wt, aes(x=condition_info, y=QY_max)) +
  geom_boxplot() + # add a boxplot layer (same as before)
  geom_point() + # add points to the boxplot
  theme_classic() + # change the theme (background etc.)
  ggtitle("Condition info vs QY_max boxplot for wildtype genotype") + # add a title to your plot
  xlab("Treatment conditions") + # add x-axis labels
  ylab("QY max") # add y-axis labels
p1_fancy

# Now let's get even fancier with some colors in there

p1_fancier <- ggplot(pD_clean_wt, aes(x=condition_info, y=QY_max)) +
  geom_boxplot(aes(color = condition_info)) + # color the boxplots by condition
  geom_point(aes(shape = condition_info, color = condition_info)) + # color the points by condition, and also change their shapes
  theme_classic() +
  ggtitle("Condition info vs QY_max boxplot for wildtype genotype with color") + 
  xlab("Treatment conditions") + 
  ylab("QY max")
p1_fancier
```

##### Specification of colors

The colors can be specified through several ways in R. There are many color names (you can run `colors()` to see the list of them or `demo("colors")` to the actual colors). You can also use hexadecimal code or functions like `hsv()` to set the colors. For simple color changes, assign a single color value to the `geom_()` function. 

```{r}
p1_violet <- ggplot(pD_clean_wt, aes(x=condition_info, y=QY_max)) +
  geom_boxplot(color = "violet") +theme_classic()
p1_violet
```

As we have seen before, you can use color scale if you specify the variable according which to color in the `aes()` function.

```{r}
p1_def_colors <- ggplot(pD_clean_wt, aes(x=condition_info, y=QY_max)) +
  geom_boxplot(aes(color = condition_info))
p1_def_colors
```

The default color scale can be modified adding `scale_color_manual()` function to the plot.
```{r}
p1_man_colors <- ggplot(pD_clean_wt, aes(x=condition_info, y=QY_max)) +
  geom_boxplot(aes(color = condition_info)) +
  scale_color_manual(values = c("violet", "turquoise", "red")) +
  theme_classic()
p1_man_colors
```
Notice that the list of colors is inside function `c()`. This is one of the most basic functions of R, combining values into vectors.

The specification of shapes of the points is similar. You can run `help(shape)` and the examples there to get more information.

The theme layer in `ggplot2` is used to customize all non-data components of plots, including the plot title, labels, text fonts, background, gridlines, and legends. The theme layer is added to the plot code using a `+` followed by the `theme_()` function. You can check out the documentation for theme by running `help(theme)`.

**Exercise 10:** Use the code for the plot `p1_fancier` and modify it in a way that the points will be black squares in all three categories. The colors of the boxes should be "aquamarine", "purple" and "darkblue".

Hint: Square is a shape number 15.

```{r}

```

**Extra exercise:** We would like to check whether the time of measurement (the time that the plants were standing by the instrument waiting for measurement) might have influenced the results. Plot the dependance of QY_max on time of measurement for different conditions and genotypes as a scatterplot. Distinguish conditions by colors of points and genotypes by shapes of points.
```{r}

```
If you succeeded, you can see that the result is not very useful. As the *psbo1cr* plants have much lower values, we can't see a possible small slope in the data.

**Extra exercise:** Make the same plot, but showing only wt and *psbo2cr* plants.

Hint: For filtering of the dataframe, you need to use several values of genotypes. For this, you shouldn't use the double equal sign operator `==`, but operator `%in%`, meaning "the value should be in the following list of values". The list of the values (vector) should be in the function `c()`.
```{r}

```

*Comment on biology: You can see that there is not any visible slope in the data. This means that there is probably no bias given by the time of the measurement.*


#### Exporting plots from R
We have seen above how to save several plots to pdf. The `ggplot` package provides also an easy way how to save plot. Here is an example how to save the fanciest plot as an PNG image.
```{r}
ggsave(filename = "Evomics2023_fanciest_plot.pdf", plot = p1_fanciest, width = 7, height = 7)
```


**Extra exercise:** Make a line plot showing NPQ (non-photochemical quenching) in the four time points for which we have the data. There should be one line per each genotype in each condition (9 lines together). Use different colors and line types to distinguish genotypes and conditions.

Hints: You can use `group_by()` and `summarise()` functions from the `dplyr` package to get the means for each category.

*Comments on biology: The non-photochemical quenching of chlorophyll fluorescence (NPQ) is a process by which the plants avoid overexcitation and damage of their photosynthetic apparatus. By this process, the energy from light that was absorbed by the chlorophyll molecules is safely converted to heat. Before the measurements, the plants were in darkness for at least 30 minutes. This caused the NPQ to be relaxed (switched off). In the beginning of each measurement, the plant was exposed to light, which induced activation of the NPQ. Thus, we should see increase of the NPQ during subsequent time points. The differences between genotypes might help with interpretation of the differences between their photosynthetic machineries.*

```{r}

```

**Treasure hunt:** Import the file `XA53_experiment.txt` from your working folder and plot the data. Can you find something interesting in the data? Let us know if you find an interesting pattern.

Hint: This file is tab-separated. Use the `read.table()` function with arguments `sep = "\t"` (separator of the fields is tabulator) and `header = T` (to use the first line of the file as column names).

```{r}

```

