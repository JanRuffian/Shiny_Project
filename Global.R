rm(list=ls())

wages <- read.dta("/Users/janruffner/Desktop/Shiny_Project/App_Wages/lse2010.dta")
wages_1 <- head(wages, 50000)
wages_1 <- wages_1[wages_1$taetigk!=-9, ]



wages_1 <- wages_1 %>% mutate(Sex = ifelse(geschle==1, "Male", "Female"))


# Create privat/public variable
wages_1 <- wages_1 %>% mutate(Sector = ifelse(privoef==2, "Private", "Public"))
# Create variable for dedication



#Create variable for eduction
wages_1$education <- as.factor(wages_1$ausbild)


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




