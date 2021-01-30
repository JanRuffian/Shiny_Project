library(shiny)
library(foreign)
library(shinydashboard)




# Define UI for application that draws a histogram
shinyUI(dashboardPage( 
    dashboardHeader(title = "Wage Determinants"), 
    dashboardSidebar(
      sidebarUserPanel("Jan Ruffner"),
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
                        collapsible = TRUE, width=6, "The application presents the wages in Switzerland
                        in the year 2018. Furthermore the app gives insights about the main
                        determinants of the wages and wage distribution. Important factors
                        are gender, experience, industry, job type, foreign status and location.
                        
                        I work with the wage structure survey. The LSE is a survey which is sent to a representative sample
                        of enterprises every two years by the Swiss Federal Statistical Oce since 1994. Participation is mandatory. 
                        The survey includes enterprises from all industries of the manufacturing sector and the service sector. 
                        There is data on the establishment level such as the size and there is detailed information about individual 
                        characteristics of every employee such as the residence status, the occupation, the education level and the wages.
                        It captures therefore a large amount of information on the Swiss workforce. Excluded are just apprentices and trainees, 
                        home workers, employees working exclusively on commission basis, workers who are mainly active abroad, proprietors of a firm, 
                        workers with a reduced wage (e.g. due to invalidity), and workers employed in firms with less than 2 employees.  "
                        ),
                        img(src="Lohnbuch2018.png", height="40%", width="40%")      
                              ),
                      fluidRow(
                        box(
                          title = "Findings", status = "primary", solidHeader = TRUE,
                          collapsible = TRUE, width=6, "The app 
                          1. 
                          asdf asfdasdfasfdasfdasfdsadfasdfasdffdsadffd  sa dfas fsa aadfsa df
                          <br/>
                          <br/>
                          a sdfasdf ass asdf as fs fas dfsadf asdf safsadf asfa ds aafs asdf sd faadfsf asf fsassd assfd sadf as
                          <br/>
                          <br/>
                          a sdf asdf asfd sfa dasf asf sfda fsddsfaa"
                          )   
                      
                              )
              ),
              
              
              
              tabItem(tabName = "Gender",
                      
                      fluidRow(infoBoxOutput("mean_wage_male", width=5),
                               infoBoxOutput("mean_wage_female", width=5)
                              ),
                      fluidRow(
                              box(
                              title = "Distribution of monthly wages by gender", status = "primary", solidHeader = TRUE,
                              width=5, plotOutput("wagedistribution_m_f", width="75%")
                                ),
                              box(
                                title = "Average wage by position", status = "primary", solidHeader = TRUE,
                                width=5, plotOutput("wage_gender_position", width="75%")
                              ),
                              box(
                                title = "Filter", status = "primary", solidHeader = TRUE,
                                collapsible = TRUE, width=2,
                                "Choose the industry:",
                                selectInput(inputId="indSelector", label="Select an industry:", choices=SelectIndustry, selected = "Education")
                                )
                              ),
    
                      fluidRow(
                        box(
                        title = "Description", status = "primary", solidHeader = TRUE,
                        collapsible = TRUE, width=10, "1.	The first graph shows the distribution of the wages in Switzerland 
                        based on the selected industry. In nearly every industry male earn more in comparison to females. In 
                        some industries this effect is more pronounced. For example, in the financial industry more than 50 % 
                        of male earn more than 10’000 CHF. For women this is not the case. A high share (around 70%) earn less 
                        than 10’000 CHF. 
                        2.	The second graphic show that the effect is still there even if we look at the hierarchy levels. 
                        One can see that male earn morn in every hierarchy level in comparison to females. Again, there are 
                        certain industries where this effect is more accentuated."
                      )
                      )
                      ),
              
              
              
              tabItem(tabName = "Experience",
                      
                      fluidRow(infoBoxOutput("experience_avg", width=4),
                               infoBoxOutput("age_avg", width=4)
                      ),
                      
                      fluidRow(
                      box(
                        title = "Wage developement with experience and age", status = "primary", solidHeader = TRUE,
                        width=8, plotOutput("wage_experience_m_f", width="75%")
                        ),
                      box(
                        title = "Filter", status = "primary", solidHeader = TRUE,
                        collapsible = TRUE, width=4,
                        "Adjust the gender or industry",
                        selectInput(inputId="expageSelector", label="Select Experience or Age:", choices=SelectExpAge, selected = "Age"),
                        selectInput(inputId="positionSelector", label="Select a Position:", choices=SelectPosition, selected="Bottom Squad"),
                        selectInput(inputId="educationSelector", label="Select an Education level:", choices=SelectEducation, selected="University (UNI, ETH)")
                        )
                              ),
                      
                      box(
                        title = "Description", status = "primary", solidHeader = TRUE,
                        collapsible = TRUE, width =8, "The wage increases with every year 
                        of experience. The increase is the largest in the first
                        couple of years and then the increase declines a little bit 
                        by every year. With 15 years of experience there is no more 
                        wage increase but rather a decline of the wages./n
                        /n With over 40 years of experience there is a increase of the
                        wages again. But this increase appears mainly due to the sammple.
                        A lot of people drop out of the labor market. The one who stay 
                        are the one which earned the most in the past."
                      )
              ),
              
              
              
              tabItem(tabName = "Industry",
                      
                      fluidRow(infoBoxOutput("industry_max", width=4),
                               infoBoxOutput("industry_min", width=4)
                      ),
                      
                      box(
                        title = "Wage by industry", status = "primary", solidHeader = TRUE,
                        width=8, plotOutput("wage_industry")
                      ),
                      box(
                        title = "Filter", status = "primary", solidHeader = TRUE,
                        collapsible = TRUE, width=4,
                        "Adjust the gender or industry",
                        selectInput(inputId="indSelector2", label="Select an industry:", choices=SelectIndustry2, 
                                    selected=c("Accommodation","Computer programming, consultancy and related activities", 
                                               "Financial service activities, except insurance and pension funding",
                                               "Human health activities", "Real estate activities", "Telecommunications",
                                               "Manufacture of wood", "Manufacture of textiles", "Legal and accounting activities",
                                               "Education", "Employment activities", "Creative, arts and entertainment activities"), multiple = TRUE)
                        
                      ),
                      
                      box(
                        title = "Description", status = "primary", solidHeader = TRUE,
                        collapsible = TRUE, width=8, "The highest paying industry in Switzerland is the financial service 
                        with an average monthly wage of 13’300 CHF directly followed by the pharmaceutical industry with 11’254 CHF. 
                        The lowest paying industry is currently the “Other personal service activities” with average monthly wage 
                        of 4’138 CHF. Note: The data is devided in 40 industries based NOGA codes. The industry classification can 
                        be found here: link"
                        
                      )
                      
              ),
              
              tabItem(tabName = "Location",
                      
                      fluidRow(infoBoxOutput("canton_max", width=5),
                               infoBoxOutput("canton_min", width=5)
                               
                              ),
                      fluidRow(
                      box(
                        title = "Wage by canton", status = "primary", solidHeader = TRUE,
                        width=5, plotOutput("wage_map")
                        ),
                      box(
                        title = "Wage by canton", status = "primary", solidHeader = TRUE,
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
                          title = "Profile", status = "primary", solidHeader = TRUE,
                          collapsible = TRUE, width=10, "Jan Ruffner is currently a business intelligence analyst
                          and manager at Wuest Partner. In the past he did his PhD at the ETH Zurich.",
                          
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
                          and manager at Wuest Partner. In the past he did his PhD at the ETH Zurich.",
                          
                        ),
                        img(src="JanRuffner.png")
                              )
                      )
                    )
                  )
))

