#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
rm(list=ls())

library(ggplot2 )
library(shiny)

mtcars <- mtcars

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
      
      #Gender

      output$wagedistribution_m_f <- renderPlot({   
        
        ggplot(data=wages_1, aes(x=mbls)) +
        geom_density(aes(color=Sex)) +
        xlim(0, 15000) +
        xlab("Monthly Wage") +
        ylab("Density")  
      
      })
 
      #Experience
      
      output$wage_experience_m_f <- renderPlot({   
        ggplot(wages_1, aes(x=dienstja, y=mbls, color=Sex))+
        geom_point()+
        geom_smooth()+
        ylim(0, 15000)+
        ggtitle("Wage development with experience")+
        ylab("Wage")+
        xlab("Years")
      })      
       
      output$plot1 <- renderPlot({
        ggplot(data=mtcars, aes(x=mpg, y=hp))+geom_point()
      })
      
      #Industry
      
      output$wage_industry <- renderPlot({
      wages_1 %>% group_by(industry) %>% 
      summarise(WagesIndustry=mean(mbls))  %>% 
      ggplot(aes(x = industry, y = WagesIndustry)) +
      geom_bar(stat = "identity")+
      coord_flip()+
      ggtitle("Average wage in the industry")
      })  
      
      output$wage_dedication <- renderPlot({
      wages_1 %>% group_by(taetigk2) %>% 
      summarise(WagesDedication=mean(mbls))  %>% 
      ggplot(aes(x = taetigk2, y = WagesDedication)) +
      geom_bar(stat = "identity")+
      coord_flip()+
      ggtitle("Average wage by dedication")
      })
        
          
      #Data Table
      output$dt1 <- renderDT({
        
        datatable(data=mtcars, list(pagelength=5, lengthMenu=c(5,10,15,20)))
        
      })
      
      #Ouput Text
      output$text1 <- renderText(paste("Jan is an amazing guy."))
      
      output$text2 <- renderText(paste("Jan is an amazing guy."))
      
      output$text3 <- renderText(paste("Jan is an amazing guy."))

})
