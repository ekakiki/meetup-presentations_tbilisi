#######################################
####### DATA MANIPULATION #############
#######################################
#Today's code
#https://github.com/rladies/meetup-presentations_tbilisi/blob/master/2017_04_11_Data%20manipulation'

rm(list=ls()) #to remove objects in environment
#CTRL+L in console to clear console in R

#use $ to refer to columns in the dataframe
#in [a,b] a-> rows, b-> columns


#One way of subsetting data
# select rows 
data[1:2,]
#select rows & columns
data[1:2, c(1:2)]
#select rows based on a condition of a variable
data[data$var1 > 2,]
#select rows based on several conditions, then select specific columns
data[data$var1 > 2 & data$var3 == 4, 5:7]
#The code lina can become too long

#Simplest way of manipulation --> transposing
#Transpose to save space
t(data) #for dataframes or matrices
#reshape2 package also good - see below later


#Also used:
?attach
example(attach)

?aggregate


#Packages for data manipulation
install.packages("dplyr")
#install.packages("data.table")
install.packages("reshape2")
#install.packages("tidyr") - tidies your data
#install.packages("readr") - reads various forms of data into R

library("dplyr")
library("reshape2")

#######
#dplyr#

#convert to tbl_df for larger data sets - easier to work with in R
data<-tbl_df(datafile)
?tbl_df

#glimpse
glimpse(data)

#View - with a capital V!
View(data)


filter()
#filter() selects a subset of data by ROWS (data, var1, var2)
filter(data, var1=1, var2=2)
#more verbose way: data[data$var1 == 1 & data$var2 == 1, ]
#same as subset()
filter(data, var1=1 | var2=2)
filter(data, var1>5)

#To select rows by position, use slice()
slice(data, 1:10)

arrange()
#arrange() reorders rows by values of a column; can have several columns
arrange(data, var1, var2, var3)
#descending order
arrange(data, desc(var1))
#desc() to order columns by name
#same as data[order(data$var1, data$var2, data$var3),]
#data[order(data$var1, decreasing = TRUE),] #or data[order(-data$var1), ]


select() 
#allows to select specific part of your data by COLUMNS
# Select columns by name
select(data, var1, var2, var3)
# Select all columns between var1 and var5 (inclusive)
select(data, var1:var5)
# Select all columns except those from var1 to var5 (inclusive)
select(data, -c(var1:var5)) 
#to hide columns
select(data, -var1, -var2)
#starts_with(), ends_with(), matches() and contains()
#use rename to rename var-s
rename(data, var_1 = var1)

distinct() #to find unique values
distinct(data, var1)
distinct(data, var1, var2)


mutate() #to create new columns
mutate(data,
       a_var = var1 - var2,
       b_var = var3 / var6 * 2)


transmute() #if want to keep only newly created columns
summarise() #to summarise values
summarise(data, 
          var9 = mean(b_var, na.rm = TRUE))


sample_n() #take random sample of rows for a fixed number
sample_n(data, 10)
sample_frac() #take random sample of rows for a fixed fraction
sample_frac(data, 0.1)

group_by() #group data into rows
ungroup()

#Chaining or piping for multiple operations in one line %>%
data %>% group_by(var1) %>% mutate(var2)
data %>%
  select(var1, var2, var3)%>%
  filter(var2 > 2)
data %>% rename(var1 = avar1)

#reshaping with dplyr
gather() #columns into rows
spread() #rows into columns



##########
#reshape2#
??reshape2
#wide data - column for each variable
#long data - column for possible variable types and a column for the values of those variable
#you need long-format data more often
#especially when analysing repeated measures/ events

#first change var names into lower case if have to
names(data) <- tolower(names(data))
head()

melt() #wide --> long-format

data()

head()
str()

#need to specify the variables that uniquely identify observations

melt(data, id.vars=c("", ""))

#can also change the name of variables within melt function
melt (data, id=c(),
      varname="new_name1",
      varname2="new_name2")


cast() #long --> wide-format
#dcast for dataframes, acast for returning a vector, matrix or array
#cast uses a formula within the command line to describe data

#idvar1+idvar2 define the rows, ~variable defines the columns
#dataname <- dcast(melteddata, idvar1 + idvar 2 ~ variable)
#id vars will be separate columns in the new dataset

#in some cases need to add the value variable too
#dataname <- dcast(melteddata, idvar1 + idvar 2 ~ variable, value.var="value")

#run additional operations - mean, median, sum
#dcast(melteddata, var1 ~ variable, fun.aggregate = mean, 
      #na.rm = TRUE) #na.rm=T --> t remova NAs


??readr
