library(shiny)
library(foreign)
library(shinydashboard)


# Define UI for application that draws a histogram
shinyUI(dashboardPage( 
    dashboardHeader(title = "Wage Determinants"), 
    dashboardSidebar(
      sidebarUserPanel("Your Name"),
      sidebarMenu(
        menuItem(text="Gender", tabName = "Gender", icon = icon("map")),
        menuItem(text="Experience", tabName = "Experience", icon = icon("map")),
        menuItem("Industry", tabName = "Industry ", icon = icon("database")),        
        menuItem(text="Location", tabName = "Location", icon = icon("map")),
        menuItem("Data", tabName = "Data", icon = icon("data")),
        menuItem("My Profile", tabName = "Profile", icon = icon("clock"))
      )
    ), 
    dashboardBody(
            tabItems(
              tabItem(tabName = "Gender",
                      plotOutput("wagedistribution_m_f")
                      ),
              
              tabItem(tabName = "Experience",
                      plotOutput("wage_experience_m_f")
              ),
              
              tabItem(tabName = "Industry",
                      plotOutput("wage_industry")
              ),
              
              tabItem(tabName = "Data",
                      DTOutput("dt1")
                      ),
              
              tabItem(tabName = "Profile",
                      fluidRow(
                      column(width=3, verbatimTextOutput("text1")), 
                      column(width=3, verbatimTextOutput("text2")),
                      column(width=3, verbatimTextOutput("text3"))
                              )
                      )
                    )
                  )
))

