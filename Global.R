rm(list=ls())
library(foreign)
library(ggplot2)
library(dplyr)
library(RSwissMaps)
library(DT)

wages <- read.dta("/Users/janruffner/Desktop/Shiny_Project/lse2010.dta")
wages_1 <- head(wages, 2000000)

#####################################################################
#####################################################################
######################Creating variables ###########################
#####################################################################
#####################################################################

# Delete where dedication is NA
wages_1 <- wages_1[wages_1$taetigk!=-9, ]

# Create female and male
wages_1 <- wages_1 %>% mutate(Sex = ifelse(geschle==1, "Male", "Female"))

# Create privat/public variable
wages_1 <- wages_1 %>% mutate(Sector = ifelse(privoef==2, "Private", "Public"))

# Create variable for dedication
taetigk <- c(10,11,12,13,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,40)
taetigk2 <- c(
"Manufacturing, processing",	
"Construction",	
"Machinery",	
"Restoration, Crafts",	
"Definition of corporate strategy", 	
"Accounting and personel",	
"Secreterial, office work",	
"Other administrative functions",	
"Logistic and staff duties",	
"Evaluation, consultancy, certification",
"Trade in Goods",
"Retail Sales of Goods and Services",	
"Research and development", 	
"Analysis, programming, operating",
"Plan, construct, draw, design", 
"Transport and communication",	
"Security, surveillance",
"Medical, nursing and social functions",	
"Personal hygiene, dress care",
"Cleaning and public hygiene",
"Education",
"Hotel, catering trade, housework",	
"Culture, information and recreation", 
"Other")
dedication <- data.frame(taetigk, taetigk2)
wages_1 <- wages_1 %>% left_join(dedication)

# Create variable for industry
nog_2_08 <- sort(unique(wages$nog_2_08))
industry <- c("Forestry and logging", #2
  "Mining of coal and lignite", #5
  "Manufacture of food products", #10
  "Manufacture of tobacco products", #12
  "Manufacture of textiles", #13
  "Manufacture of wood", #16
  "Manufacture of coke and refined petroleum products", #19
  "Manufacture of basic pharmaceutical products and pharmaceutical preparations", #21
  "Manufacture of rubber and plastic products", #22
  "Manufacture of basic metals ", #24
  "Manufacture of computer, electronic and optical products", #26
  "Manufacture of electrical equipment", #27
  "Manufacture of machinery and equipment", #28
  "Manufacture of motor vehicles, trailers and semi-trailers", #29
  "Manufacture of furniture", #31
  "Electricity, gas, steam and air conditioning supply", #35
  "Water collection, treatment and supply", #36
  "Construction of buildings", #41
  "Wholesale and retail trade and repair of motor vehicles and motorcycles", #45
  "Retail trade, except of motor vehicles and motorcycles", #47
  "Land transport and transport via pipelines", #49
  "Postal and courier activities", #53
  "Accommodation", #55 
  "Publishing activities", #58
  "Telecommunications", #61
  "Computer programming, consultancy and related activities", #62
  "Financial service activities, except insurance and pension funding", #64
  "Insurance, reinsurance and pension funding, except compulsory social security", #65
  "Real estate activities", #68
  "Legal and accounting activities", #69
  "Scientific research and development", #72
  "Advertising and market research", #73
  "Rental and leasing activities", #77
  "Employment activities", #78
  "Public administration and defence; compulsory social security", #84
  "Education", #85
  "Human health activities", #86
  "Creative, arts and entertainment activities", #90
  "Activities of membership organisations", #94
  "Other personal service activities" #96
  ) 
industry <- data.frame(nog_2_08, industry)
wages_1 <- wages_1 %>% left_join(industry)

# Create variable for position
berufst <- sort(unique(wages_1$berufst))
position <- c("Not available", #2,
              "Top management",
              "Middle squad",
              "Lower squad",
              "Bottom squad",
              "Without management function"
              )
position <- data.frame(berufst, position)
wages_1 <- wages_1 %>% left_join(position)              

# Create variable for education
ausbild <- sort(unique(wages_1$ausbild))
education <- c("University (UNI, ETH)", #2,
              "University of Applied Sciences (FH), PH",
              "Higher vocational training, technical school",
              "Teacher licence",
              "Matura",
              "Completed vocational training",
              "In-house vocational training",
              "Without completed vocational training",
              "Other qualifications",
              "Missing value"
)
education <- data.frame(ausbild, education)
wages_1 <- wages_1 %>% left_join(education)      

#####################################################################
#####################################################################
######################Creating KPIs ###########################
#####################################################################
#####################################################################

wages_mean <- round(mean(wages_1$mbls),0)
wages_median <- round(median(wages_1$mbls),0)
wages_max <- round(max(wages_1$mbls),0)
wages_min <- round(min(wages_1$mbls),0)

#####################################################################
#####################################################################
######################Creating new dataframes #######################
#####################################################################
#####################################################################

#gender/position dataset
wage_gender_position <- wages_1 %>% group_by(Sex, position, industry) %>% summarize(mean_wage=mean(mbls), number=n()) %>% ungroup()  

#experience dataset
wage_experience <- wages_1 %>% group_by(dienstja, Sex, position, education) %>% summarize(mean_wage=mean(mbls), number=n())
wage_experience$Cat <- "Experience"
wage_experience <- wage_experience %>% rename(Year="dienstja")
wage_age <- wages_1 %>% group_by(alter, Sex, position, education) %>% summarize(mean_wage=mean(mbls), number=n())
wage_age$Cat <- "Age"
wage_age <- wage_age %>% rename(Year="alter")
wage_experience_age <- rbind(wage_experience,wage_age)

#industry dataset
wage_industry<- wages_1 %>% group_by(industry, Sex) %>% summarise(WagesIndustry=mean(mbls), weight=n())

#industry dataset for kpis
wage_industry_kpis <- wages_1 %>% group_by(industry) %>% summarise(WagesIndustry=mean(mbls), weight=n())

# canton dataset
dt <- can.template(2016)
wages_1 <- wages_1 %>% mutate(name=arbkto)
wages_1 <- wages_1 %>% left_join(dt)
wage_canton <- wages_1 %>% group_by(name, bfs_nr) %>% summarize(values=round(mean(mbls),0))

# data dataset
wages_data <- wages_1 %>% rename(corporateID = "burnr_n", gender="Sex", 
                              experience = "dienstja", age = "alter", wage="mbls",canton="arbkto",
                              dedication="taetigk2") %>% head(200) %>%
                              select(canton, corporateID, industry, gender, experience, age, position, education,
                              dedication, wage)

# Create distribution dataset
wages_1 <- wages_1 %>% mutate(mbls2 = ifelse(mbls<1000, 1, ifelse(mbls>1000 & mbls<=2000, 2, ifelse(mbls>2000 & mbls<=3000, 3, 
          ifelse(mbls>3000 & mbls<=4000, 4, ifelse(mbls>4000 & mbls<=5000, 5, ifelse(mbls>5000 & mbls<=6000, 6, ifelse(mbls>6000 & mbls<=7000, 7, 
          ifelse(mbls>7000 & mbls<=8000, 8, ifelse(mbls>8000 & mbls<=9000, 9,ifelse(mbls>9000 & mbls<=10000, 10,
          ifelse(mbls>10000 & mbls<=11000, 11,ifelse(mbls>11000 & mbls<=12000, 12,ifelse(mbls>12000 & mbls<=13000, 13,
          ifelse(mbls>13000 & mbls<=14000, 14, ifelse(mbls>14000 & mbls<=15000, 15, 16))))))))))))))))

wage_distribution <- wages_1 %>% group_by(industry, Sex, mbls2) %>% summarise(sum_people = n())
wage_distribution <- wage_distribution %>% group_by(industry, Sex) %>% summarize(sum_people_group=sum(sum_people)) %>% 
                      left_join(wage_distribution) 
wage_distribution$ratio = wage_distribution$sum_people/wage_distribution$sum_people_group

#####################################################################
#####################################################################
######################Creating selectors ###########################
#####################################################################
#####################################################################

SelectGender=unique(wages_1$Sex)
SelectSector=unique(wages_1$Sector)
SelectExpAge=unique(wage_experience_age$Cat)
SelectPosition=unique(wage_experience_age$position)
SelectEducation=unique(wage_experience_age$education)
SelectIndustry=unique(wage_gender_position$industry)
SelectIndustry2=unique(wage_industry$industry)
SelectCanton=unique(wage_canton$name)








