library(shiny)
library(foreign)
library(shinydashboard)
library(DT)



# Define UI for application that draws a histogram
shinyUI(dashboardPage( 
    dashboardHeader(title = "Wage Determinants in Switzerland", titleWidth = 350), 
    dashboardSidebar(
      sidebarUserPanel("Menu"),
      sidebarMenu(
        menuItem(text="Introduction", tabName = "Introduction", icon = icon("map")),
        menuItem(text="Gender", tabName = "Gender", icon = icon("venus-mars")),
        menuItem(text="Experience", tabName = "Experience", icon = icon("blind")),
        menuItem("Industry", tabName = "Industry ", icon = icon("industry")),        
        menuItem(text="Location", tabName = "Location", icon = icon("globe")),
        menuItem("Data", tabName = "Data", icon = icon("database")),
        menuItem("My Profile", tabName = "Profile", icon = icon("clock"))
      )
    ), 
    dashboardBody(
            tabItems(
              tabItem(tabName = "Introduction",
                      
                      fluidRow(infoBoxOutput("mean_wage", width=4),
                               infoBoxOutput("max_wage", width=4),
                               infoBoxOutput("min_wage", width=4)
                              ),
                      
                      fluidRow(
                        box(
                        title = "Aim", status = "primary", solidHeader = TRUE,
                        collapsible = TRUE, width=6, HTML("The application presents the wages in Switzerland
                        in the year 2018. Furthermore, the app gives insights about the main
                        determinants of the wages and wage distribution. Important factors
                        are:<br/>
                        - Gender <br/>
                        - Experience <br/>
                        - Education <br/>
                        - Management position<br/>
                        - Industry <br/>
                        - Location <br/>
                        - Dedication <br/>
                        On the one hand it will help companies to set the right wages to be competitive. 
                        On the other hand it will inform the state if there is discrimination for example 
                        between gender and nationality.")
                        ),img(src="Lohnbuch2018.png", height="40%", width="40%")      
                      ),
                        
                      fluidRow(
                        box(
                          title = "Findings", status = "primary", solidHeader = TRUE,
                          collapsible = TRUE, width=6, 
                          HTML("1. Gender: Males earn on average 27.6% more than females. Annualy this is a difference of around 21'500 CHF. When we account for industry
                          or management position this difference gets smaller but a certain wage difference between gender remains. <br/>
                          2. Age: The average salary increases till the year of 40. For top management position this effect holds longer till the age of 45.<br/>   
                          3. Industry, average monthly wage: Finance: 11'126 CHF, Pharma: 10’467 CHF, Other personal service activities: 4'537 CHF <br/>
                          4. Location: The highest paying canton Geneva pays 26% more in comparison to the lowest paying canton Tessin, which corresponds to 
                          an annual difference of around 33'600 CHF")
                          )   
                              ),
                      
                      fluidRow(
                        box(
                          title = "Data", status = "primary", solidHeader = TRUE,
                          collapsible = TRUE, width=6, "
                          The wage structure survey (LSE) is a survey which is sent to a representative sample
                          of enterprises by the Swiss Federal Statistical Office in 2018. Participation is mandatory. 
                          The survey includes enterprises from all industries of the manufacturing sector and the service sector. 
                          There is data on the establishment level such as the size and there is detailed information about individual 
                          characteristics of every employee such as the residence status, the occupation, the education level and the wage.
                          It captures therefore a large amount of information on the Swiss workforce (sample of 1'900'000 workers). Excluded are just apprentices and trainees, 
                          home workers, employees working exclusively on commission basis, workers who are mainly active abroad, proprietors of a firm, 
                          workers with a reduced wage (e.g. due to invalidity), and workers employed in firms with less than 2 employees." 
                        )   
                      )
                      
              ),
              
              
              
              tabItem(tabName = "Gender",
                      
                      fluidRow(infoBoxOutput("mean_wage_male", width=5),
                               infoBoxOutput("mean_wage_female", width=5)
                              ),
                      fluidRow(
                              box(
                              title = "Distribution of average wage by gender", status = "primary", solidHeader = TRUE,
                              width=5, plotOutput("wagedistribution_m_f", width="75%")
                                ),
                              box(
                                title = "Average wage by management position and gender", status = "primary", solidHeader = TRUE,
                                width=5, plotOutput("wage_gender_position", width="75%")
                              ),
                              box(
                                title = "Filter", status = "primary", solidHeader = TRUE,
                                collapsible = TRUE, width=2,
                                selectInput(inputId="indSelector", label="Select an industry:", choices=SelectIndustry, selected = "Education")
                                )
                              ),
    
                      fluidRow(
                        box(
                        title = "Description", status = "primary", solidHeader = TRUE,
                        collapsible = TRUE, width=10, HTML("The first graph shows the distribution of the wages in Switzerland 
                        based on the selected industry. In nearly every industry males earn more in comparison to females. In 
                        some industries this effect is more pronounced. For example, in the financial industry more than 50 % 
                        of the males earn more than 10’000 CHF. For women this is not the case. A high share (around 70%) earn less 
                        than 10’000 CHF. <br/>
                        The second graphic shows that the effect is still there even if we look at the hierarchy levels. 
                        One can see that males earn more for every hierarchy level in comparison to females. Again, there are 
                        certain industries where this effect is more accentuated.")
                      )
                      )
                      ),
              
              
              
              tabItem(tabName = "Experience",
                      
                      fluidRow(infoBoxOutput("experience_avg", width=4),
                               infoBoxOutput("age_avg", width=4)
                      ),
                      
                      fluidRow(
                      box(
                        title = "Average wage developement with experience and age", status = "primary", solidHeader = TRUE,
                        width=8, plotOutput("wage_experience_m_f", width="75%")
                        ),
                      box(
                        title = "Filter", status = "primary", solidHeader = TRUE,
                        collapsible = TRUE, width=4,
                        selectInput(inputId="expageSelector", label="Select Experience or Age:", choices=SelectExpAge, selected = "Age"),
                        selectInput(inputId="positionSelector", label="Select a Management Position:", choices=SelectPosition, selected="Bottom Squad"),
                        selectInput(inputId="educationSelector", label="Select an Education level:", choices=SelectEducation, selected="University (UNI, ETH)")
                        )
                              ),
                      fluidRow(
                      box(
                        title = "Description", status = "primary", solidHeader = TRUE,
                        collapsible = TRUE, width =8, "For all the subgroups there is a strong wage 
                        increase in the beginning of the career. The wage increases from 25 till 40 
                        nearly every year. Nevertheless, the wage changes become smaller and smaller 
                        and stagnate after 40. For people in higher management position this effect remains 
                        constant longer in comparison to other groups. But even for this positions the wages 
                        stagnate around the age of 45."
                      )
                      )
              ),
              
              
              
              tabItem(tabName = "Industry",
                      
                      fluidRow(infoBoxOutput("industry_max", width=4),
                               infoBoxOutput("industry_min", width=4)
                      ),
                      fluidRow(
                      box(
                        title = "Wage by industry", status = "primary", solidHeader = TRUE,
                        width=8, plotOutput("wage_industry")
                      ),
                      box(
                        title = "Filter", status = "primary", solidHeader = TRUE,
                        collapsible = TRUE, width=4,
                        selectInput(inputId="indSelector2", label="Select an industry:", choices=SelectIndustry2, 
                                    selected=c("Accommodation","Computer programming, consultancy and related activities", 
                                               "Financial service activities, except insurance and pension funding",
                                               "Human health activities", "Real estate activities", "Telecommunications",
                                               "Manufacture of wood", "Manufacture of textiles", "Legal and accounting activities",
                                               "Education", "Employment activities", "Creative, arts and entertainment activities"), multiple = TRUE)
                        
                      )
                      ),
                      fluidRow(
                      box(
                        title = "Description", status = "primary", solidHeader = TRUE,
                        collapsible = TRUE, width=8, "The highest paying industry in Switzerland is the financial service sector
                        with an average monthly wage of 11'126 CHF directly followed by the pharmaceutical industry with 10'467 CHF. 
                        The lowest paying industry is currently the “Other personal service activities” with average monthly wage 
                        of 4'573 CHF. The financial sector therefore pays 143 percent more in compariso this sector. 
                        Note: The data is devided in 40 industries based NOGA codes. This industry classification can 
                        be found here: ", 
                         urlNogaCodes <- a("Noga Codes", href="https://www.bfs.admin.ch/bfs/en/home/statistics/industry-services/nomenclatures/noga/publications-noga-2008.html")
                      )
                      )
              ),
              
              tabItem(tabName = "Location",
                      
                      fluidRow(infoBoxOutput("canton_max", width=5),
                               infoBoxOutput("canton_min", width=5)
                               
                              ),
                      fluidRow(
                      box(
                        title = "Average wage by canton", status = "primary", solidHeader = TRUE,
                        width=5, plotOutput("wage_map")
                        ),
                      box(
                        title = "Average wage by canton", status = "primary", solidHeader = TRUE,
                        width=5, plotOutput("wage_canton")
                      ),
                      box(
                        title = "Filter", status = "primary", solidHeader = TRUE,
                        collapsible = TRUE, width=2,
                        selectInput(inputId="canSelector", label="Select a canton:", choices=SelectCanton, selected=SelectCanton, multiple = TRUE)
                      )
                              ),
                      fluidRow(
                        box(
                          title = "Description", status = "primary", solidHeader = TRUE,
                          collapsible = TRUE, width=10, "
                          The monthly average wage between the 26 cantons in Switzerland differs
                          substantially. In Geneva, the highest paying canton, the average monthly wage is around 9’000 CHF 
                          whereas it is in the canton of Tessin around 6’200 CHF (lowest paying canton).  This is a difference 
                          of around 2’800 CHF which corresponds to a difference of 45 percent. Annually this makes a difference
                          of around 33’600 CHF.",
                          )
                      )
                      ),
              
              tabItem(tabName = "Data",
                      DTOutput("dt1")
                      ),
              
              tabItem(tabName = "Profile",
                      fluidRow(
                        box(
                          title = "Profile", status = "primary", solidHeader = TRUE,
                          collapsible = TRUE, "Jan Ruffner is currently a business intelligence analyst
                          and manager at Wuest Partner. In the past he did his PhD at the ETH Zurich in Economics and Applied Statistics. 
                          Here you find my"
                          , urlLinkedin <- a("Linkedin Profile", href="https://www.linkedin.com/in/jan-ruffner-phd-b1112b56/"),  
                          "and my", urlGithub <- a("Github Profile", href="https://github.com/JanRuffian"), "."
                          
                        ),
                        img(src="JanRuffner.png")
                              )
                      )
                    )
                  )
))

