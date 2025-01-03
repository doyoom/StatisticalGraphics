---
title: "Homework 1"
author: "Doyoon Kim  \nDepartment of Data Science  \nSchool of Artificial Intelligence
  \ \nEwha Womans University\n"
date: 'Due by: Sunday, September 22, 2024, at 11:59 PM'
output:
  html_document: default
  pdf_document: default
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
library(data.table)
library(dslabs)
library(dplyr)
library(ggplot2)
```

# Logistics

* Students are encouraged to collaborate and discuss course problems with peers, instructors, or AI tools to enhance their understanding.
* However, when writing up their solutions and programming codes, students are required to do this on their own, **without copying or plagiarizing from another source**.
* All solutions and code must be the student’s own work.
* Copying or plagiarizing from any source, including other students or AI generated content, is strictly prohibited and will result in a score of zero for that assignment or exam.

# Problem 1: Intro to R

## Problem 1-1 [1 point]

Install and load the `stringr` package.

```{r, echo=T, message=F, warning=F, eval=F}
install.packages("stringr") 
library(stringr)
```

### Solution


## Problem 1-2 [1 point]

What is the name of a function that splits a string in `stringr` R package? Look into the help file to find a function. If you see multiple possibilities, use one that does _not_ end in `_all`.

### Solution

```{r, echo=T, message=F, warning=F}
?str_split
```



## Problem 1-3 [2 points]

```{r echo=T, message=F, warning=F, eval=F}
name <- "Doyoon Kim"
first_name <- str_split(name, " ")[[1]][1]
first_name  # print the first name
```


# Problem 2: dplyr

## Problem 2-1 [3 points]

```{r, eval=F, message=F, warning=F}
library(dplyr)
library(dslabs)
data(murders)
total_murders <- sum(murders$total)
total_population <- sum(murders$population)
murder_rate <- (total_murders / total_population) * 10^6
murder_rate  
```

### Solution
```{r, eval=T, message=F, warning=F}
library(dplyr)
library(dslabs)
data(murders)
total_murders <- sum(murders$total)
total_population <- sum(murders$population)
murder_rate <- (total_murders / total_population) * 10^6
murder_rate
```

## Problem 2-2 [3 points]


```{r, eval=F, message=F, warning=F}
filtered_scores <- nyc_regents_scores %>%
  filter(!is.na(score))
filtered_scores <- filtered_scores %>%
  mutate(total = rowSums(across(starts_with("subject"), ~ replace_na(.x, 0)), na.rm = TRUE))
filtered_scores 
```

### Solution

```{r, eval=F, message=F, warning=F}
filtered_scores <- nyc_regents_scores %>%
  filter(!is.na(score)) %>%
  mutate(total = rowSums(across(starts_with("subject"), ~ replace_na(.x, 0)), na.rm = TRUE))
filtered_scores
```


## Problem 2-3 [4 points]

The dataset `us_contagious_diseases`, includes columns for `disease`, `state`, `year`, `weeks_reporting`, `count`, and `population`. Write an R code snippet that filters out the states "Hawaii" and "Alaska" and selects rows for the specified disease "Measles". Calculate the rate of the disease per 100,000 people per year, assuming 52 weeks in a year. 

```{r, eval=F, message=F, warning=F}
data(us_contagious_diseases)
?us_contagious_diseases # detailed explanation of the data
dat <- us_contagious_diseases |>
filter(disease == "Measles", !state %in% c("Hawaii", "Alaska")) |>
  mutate(rate = (count / population) * 100000) |>
  mutate(rate = rate * 52 / weeks_reporting) # converts the disease rate reported over a certain number of weeks into an annual rate by adjusting for the length of the reporting period
dat 
```

### Solution

```{r, eval=F, message=F, warning=F}
dat <- us_contagious_diseases |>
  filter(disease == "Measles", !state %in% c("Hawaii", "Alaska")) |>
  mutate(rate = (count / population) * 100000) |>
  mutate(rate = rate * 52 / weeks_reporting)
dat
```




# Problem 3: data.table

## Problem 3-1 [1 point]

Is original version of `murders` dataset in a `data.table` format? What is it?

```{r, echo=T, message=F, warning=F}
library(data.table)
data(murders) 
class(murders)
```

## Problem 3-2 [1 point]

Convert the `murders` data frame into a `data.table` by referencing. Explain the second to fourth lines of the code below.

```{r, eval=F, message=F, warning=F}
library(data.table)
setDT(murders)
murders[,.N]
murders[,unique(region)]
murders[,uniqueN(state)]
```

### Solution

```{r, echo=T, message=F, warning=F}
library(data.table)
setDT(murders)
murders[,.N]
murders[,unique(region)]
murders[,uniqueN(state)]
```

## Problem 3-3 [1 point]

Calculate the number of states within each region.

```{r, eval=F, message=F, warning=F}
murders[, .N, by = region]
```

### Solution

```{r, echo=T, message=F, warning=F}
murders[, .N, by = region]
```

## Problem 3-4 [1 point]

Calculate the number of states in each region where the total number of murders exceeds 20.

```{r, message=F, warning=F, eval=F}
murders[total > 20, .N, by = region] 
```

### Solution

```{r, echo=T, message=F, warning=F}
murders[total > 20, .N, by = region]
```

## Problem 3-5 [3 points]

Calculate the average population size across states within each region, but only for those states where the total number of murders exceeds 20. Moreover, name this column as a `ave_population`. You should a `data.table` with two columns at the end: `region` and `ave_population`

```{r, eval=F, message=F, warning=F}
murders[total > 20, .(ave_population = mean(population)), by = region]
```

### Solution

```{r, echo=T, message=F, warning=F}
murders[total > 20, .(ave_population = mean(population)), by = region]
```

## Problem 3-6 [3 points]

This is a [vignette introducing the `data.table` syntax](https://cran.r-project.org/web/packages/data.table/vignettes/datatable-intro.html). 

* Find a syntax that you find interesting. 
* Briefly describe its purpose.
* Provide a code example demonstrating how to use it.
```{r, echo=T, message=F, warning=F}
murders[total > 20, .(ave_population = mean(population)), by = region][order(-ave_population)]
```

# Problem 4: ggplot

## Problem 4-1 [3 points]



```{r, eval=FALSE, warning=FALSE, message=F, out.width="70%", fig.align="center"}
library(ggplot2)
data(murders)
r <- murders |> 
  summarize(pop=sum(population), tot=sum(total)) |> 
  mutate(rate = tot/pop*10^6) |> pull(rate)

murders |> 
  ggplot(aes(x =population / 10^6, y = total, label = abb)) +  
  geom_point(aes(color= region), size = 3) +
   labs(x = "Population in millions (log scale)", y = "Total number of murders (log scale)", 
       title = "US Gun Murders in 2010") +  
  geom_abline(intercept = log10(r), slope=1, lty=2, col="darkgrey") +
  geom_text(hjust = 0, nudge_x = 0.05)+
  scale_x_log10() +
  scale_y_log10() +
  scale_color_discrete(name="Region") +
  theme_bw()
```

### Solution

```{r, echo=F, warning=FALSE, out.width="70%", fig.align="center"}
library(ggplot2)
data(murders)
r <- murders |> 
  summarize(pop = sum(population), tot = sum(total)) |> 
  mutate(rate = tot / pop * 10^6) |> pull(rate)
murders |> 
  ggplot(aes(x = population / 10^6, y = total, label = abb)) +  
  geom_point(aes(color = region), size = 3) +  
  labs(x = "Population in millions (log scale)", y = "Total number of murders (log scale)", 
       title = "US Gun Murders in 2010") +  
  geom_abline(intercept = log10(r), slope = 1, lty = 2, col = "darkgrey") +  
  geom_text(hjust = 0, nudge_x = 0.05) +  
  scale_x_log10() +  
  scale_y_log10() +  
  scale_color_discrete(name = "Region") +  
  theme_bw()
```


## Problem 4-2 [4 points]

Create a barplot of NYC regent scores as we discussed during "Introduction to Data Visualization".

First, do the same as Problem 2-2 but by using `data.table` by following the below two steps.

* Convert the `nyc_regents_scores` data frame into a `data.table` by referencing. Explain the third line of the below code.

* Calculate total frequency of each score by summing up the frequency of each subject (consider NA as 0 when summing up).

* Then, with the updated data, create a barplot of NYC regent scores as we discussed during "Introduction to Data Visualization". Denote x-axis label as "Score" and y-axis label as "Score Frequency". 


### Solution




## Problem 4-3 [3 points]

Using the provided code that generates a heatmap of reported Measles cases by year and state, modify it to create a heatmap of reported cases of Hepatitis A by year and state. Include a vertical line for the Hepatitis A vaccine introduction year, which is 1995, and update the plot title to Hepatitis A.

```{r, echo=T, out.width="90%", fig.align="center", message=FALSE, warning=FALSE}
data(us_contagious_diseases)
the_disease <- "Measles"
dat <- us_contagious_diseases |>
  filter(!state%in%c("Hawaii","Alaska") & disease == the_disease) |>
  mutate(rate = count / population * 100000 * 52 / weeks_reporting) |>
  mutate(state = reorder(state, rate))

jet.colors <-
  colorRampPalette(c("#F0FFFF", "cyan", "#007FFF", "yellow", "#FFBF00", "orange", "red", "#7F0000"), bias = 2.25)
the_breaks <- seq(0, 4000, 1000)
dat |> 
  ggplot(aes(x=year, y=state, fill = rate)) +
  geom_tile(color = "white", size=0.35) +
  scale_fill_gradientn(colors = jet.colors(16), na.value = 'white',
                       breaks = the_breaks, 
                       labels = the_breaks,
                       paste0(round(the_breaks/1000),"k"),
                       limits = range(the_breaks),
                       name = "") +
  geom_vline(xintercept=1963, col = "black") +
  theme_minimal() + 
  theme(panel.grid = element_blank()) +
  coord_cartesian(clip = 'off') +
  ggtitle(the_disease) +
  ylab("") +
  xlab("") +  
  theme(legend.position = "bottom", text = element_text(size = 8)) + 
  annotate(geom = "text", x = 1963, y = 50.5, label = "Vaccine introduced", size = 3, hjust=0)
```

### Solution
```{r, echo=T, out.width="90%", fig.align="center", message=FALSE, warning=FALSE}
data(us_contagious_diseases)
the_disease <- "Hepatitis A"
dat <- us_contagious_diseases |>
  filter(!state %in% c("Hawaii", "Alaska") & disease == the_disease) |>
  mutate(rate = count / population * 100000 * 52 / weeks_reporting) |>
  mutate(state = reorder(state, rate))

jet.colors <-
  colorRampPalette(c("#F0FFFF", "cyan", "#007FFF", "yellow", "#FFBF00", "orange", "red", "#7F0000"), bias = 2.25)
the_breaks <- seq(0, 100, 25)  # Adjusted for Hepatitis A rate range
dat |> 
  ggplot(aes(x = year, y = state, fill = rate)) +
  geom_tile(color = "white", size = 0.35) +
  scale_fill_gradientn(colors = jet.colors(16), na.value = 'white',
                       breaks = the_breaks, 
                       labels = the_breaks,
                       limits = range(the_breaks),
                       name = "") +
  geom_vline(xintercept = 1995, col = "black") +  # Hepatitis A vaccine introduction year
  theme_minimal() + 
  theme(panel.grid = element_blank()) +
  coord_cartesian(clip = 'off') +
  ggtitle(the_disease) +
  ylab("") +
  xlab("") +  
  theme(legend.position = "bottom", text = element_text(size = 8)) + 
  annotate(geom = "text", x = 1995, y = 50.5, label = "Vaccine introduced", size = 3, hjust = 0)
```
