# Make rmd file without solutions
sed -z -E 's/```\{r solution([^\}]*)[^`]*```/```\{r solution\1\}\n\n```/g' Evomics_R_ggplot_solution.rmd  > Evomics_R_ggplot.rmd

# Make md file for viewing on Github
sed -z -E 's/---\r\ntitle: "([^\r\n]*)"\r\nauthor: "([^\r\n]*)"\r\ndate: "([^\r\n]*)"\r\n([^-]*)---/# \1\r\n## \2\r\n### \3\r\nThis is a copy of ".rmd" file adjusted for better viewing on GitHub.\r\n/g' Evomics_R_ggplot_solution.rmd > Evomics_R_ggplot_solution.md

# Make md file for viewing on Github
sed -z -E 's/---\r\ntitle: "([^\r\n]*)"\r\nauthor: "([^\r\n]*)"\r\ndate: "([^\r\n]*)"\r\n([^-]*)---/# \1\r\n## \2\r\n### \3\r\nThis is a copy of ".rmd" file adjusted for better viewing on GitHub.\r\n/g' Evomics_R_ggplot.rmd > Evomics_R_ggplot.md

