# ---
# title: "NYCDSA Scrapy Project"
# author: "Nick Silliman"
# date: "7/28/2021"
# ---

library(shiny)
library(shinydashboard)
library(tidyverse)
library(DT)

# setwd("~/Documents/OneDrive/Documents/School/NYCDSA/Projects/Scrapy/Shiny")

start = as.Date("2016-06-01")
end = as.Date("2021-07-01")

# Read in from Python script output
posts <- read_csv("clean_data.csv")
posts = posts %>% filter(post_time >= start, post_time <= end-1, reply_time >= start, reply_time <= end-1) %>% 
    mutate(post_month = as.Date(paste0(format(post_time, format = '%Y-%m'),"-01"))) %>% 
    mutate(reply_month = as.Date(paste0(format(reply_time, format = '%Y-%m'),"-01")))

# Use API to grab AYX stock price up to the latest post
library(quantmod)
getSymbols("AYX", from = min(posts$post_time),
    to = max(posts$post_time),warnings = FALSE,
    auto.assign = TRUE)
ayx = as.data.frame(AYX)
rm(AYX)
ayx = cbind(date = rownames(ayx), ayx)
rownames(ayx) <- 1:nrow(ayx)
ayx = ayx %>% mutate(date = as.Date(date), 
                     date_month = as.Date(paste0(format(date, format = '%Y-%m'),"-01")))
    
# Construct cumulative sum of unique users
users1 = posts %>% group_by(post_author) %>% 
    summarise(min_time = min(post_time)) %>% 
    rename('author' = post_author)
users2 = posts %>% group_by(reply_author) %>% 
    summarise(min_time = min(reply_time)) %>% 
    rename('author' = reply_author)
users = rbind(users1, users2) %>% group_by(author) %>% 
    summarise(min_time2 = min(min_time)) %>% 
    mutate(min_time2_month = as.Date(paste0(format(min_time2, format = '%Y-%m'),"-01"))) %>% 
    group_by(min_time2_month) %>% 
    summarise(count = n()) %>% 
    mutate(cumsum = cumsum(count))

