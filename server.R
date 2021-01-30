library(ggplot2 )
library(shiny)
library(foreign)
library(dplyr)
library(RSwissMaps)
library(DT)


shinyServer(function(input, output) {
      
      #Introduction
      output$mean_wage <- renderInfoBox({
        infoBox(title = "Average Monthly Wage",
                subtitle = "CHF",
                value = round(mean(wages_1$mbls),0),
                fill=TRUE
                )
      })
      
      output$max_wage <- renderInfoBox({
        infoBox(title = "Max Monthly Wage",
                subtitle = "CHF",
                value = round(max(wages_1$mbls),0),
                fill=TRUE,
                color="green",
                icon=icon("hand-o-up")
                )
      })
      
      output$min_wage <- renderInfoBox({
        infoBox(title = "Min Monthly Wage",
                subtitle = "CHF",
                value = round(min(wages_1$mbls),0),
                fill=TRUE,
                color="red",
                icon=icon("hand-o-down")
                )
      })
      
      
      #Gender
      filter_wage_gender_position <- reactive ({
                filterData_wage_gender_position <- wage_industry[wage_industry$industry==input$indSelector, ]
                return(filterData_wage_gender_position)
      })
      
      output$mean_wage_female <- renderInfoBox({
        data=filter_wage_gender_position()
        infoBox(title = "Average Monthly Wage (by selected industry)",
                subtitle = "CHF",
                value = round(mean(data[data$Sex=="Female","mean_wage"]$mean_wage),0), 
                fill=TRUE,
                icon=icon("female")
                )
      })
      
      output$mean_wage_male <- renderInfoBox({
        data=filter_wage_gender_position()
        infoBox(title = "Average Monthly Wage (by selected industry)",
                subtitle = "CHF",
                value = round(mean(data[data$Sex=="Male","mean_wage"]$mean_wage),0),
                fill=TRUE,
                color="yellow",
                icon=icon("male")
                )
      })

      filter_wage_gender_distribution <- reactive ({
                filterData_wage_gender_distribution <- wage_distribution[wage_distribution$industry==input$indSelector, ]
                return(filterData_wage_gender_distribution)
      })
      
      output$wagedistribution_m_f <- renderPlot({   
        filter_wage_gender_distribution() %>% 
          ggplot(aes(x=mbls2, y=ratio))+geom_bar(stat="identity", aes(fill=Sex), position="dodge")+
          ylab("Density")+xlab("Monthly wages")+
          scale_x_continuous(breaks = 1:16, labels=c("0-1000","1000-2000","2000-3000","3000-4000","4000-5000","5000-6000","6000-7000",
                                                     "7000-8000","8000-9000","9000-10000","10000-11000","11000-12000",
                                                     "12000-13000","13000-14000","14000-15000","15000<"), guide = guide_axis(angle = 90))+
          theme(legend.position="bottom")
      })
 
      filter_wage_gender_position <- reactive ({
        filterData_wage_gender_position <- wage_gender_position[wage_gender_position$industry==input$indSelector, ]
        return(filterData_wage_gender_position)
      })          
      
      output$wage_gender_position <- renderPlot({
      ggplot(filter_wage_gender_position(), aes(x= reorder(position, mean_wage), y=mean_wage))+ 
        geom_bar(aes(fill=Sex), position='dodge', stat = "identity")+
        xlab("Management Position")+
        ylab("Monthly Wage")+
        theme(legend.position="bottom")+
        coord_flip()  
      })  
 
      #Experience
      filter_wage_experience <- reactive ({
        filterData_wage_experience <- wage_experience_age[wage_experience_age$Cat==input$expageSelector & 
                                                            wage_experience_age$position==input$positionSelector &
                                                            wage_experience_age$education==input$educationSelector, ]
        filterData_wage_experience %>% group_by(Cat, position) %>% summarize()
        return(filterData_wage_experience)
      })
      
      output$experience_avg <- renderInfoBox({
        data = filter_wage_experience()
        infoBox(title = "Average Experience",
                subtitle = "Years",
                value = round(mean(wages$dienstja), 0),
                fill=TRUE,
                color="yellow",
                icon=icon("blind")
                )
      })
      
      output$age_avg <- renderInfoBox({
        infoBox(title = "Average Age",
                subtitle = "Years",
                value = round(mean(wages_1$alter),0),
                fill=TRUE,
                icon=icon("blind")
                )
      })
      
      output$wage_experience_m_f <- renderPlot({   
        ggplot(filter_wage_experience(), aes(x=Year, y=mean_wage, color=Sex, size=number))+
          geom_point()+
          ylim(0, 18000)+
          xlim(20,75)+
          ylab("Monthly Wage")+
          xlab("Age or Experience")
      })      
       
      output$plot1 <- renderPlot({
        ggplot(data=mtcars, aes(x=mpg, y=hp))+
        geom_point()
      })
      
      #Industry
      filter_wageindustry_kpis <- reactive ({
        filterData_wageindustry_kpis <- wage_industry_kpis[wage_industry_kpis$industry %in% input$indSelector2, ]
        return(filterData_wageindustry_kpis)
      })           

      output$industry_max <- renderInfoBox({
        data=filter_wageindustry_kpis()
        infoBox(title = data[data$WagesIndustry == max(data$WagesIndustry),"industry"],
                subtitle = "Top industry: Monthly average wage (CHF)",                
                value = round(max(data$WagesIndustry), 0),
                fill=TRUE,
                color="green",
                icon=icon("hand-o-up")
                )
      })
      
      output$industry_min <- renderInfoBox({
        data=filter_wageindustry_kpis()
        infoBox(title = data[data$WagesIndustry == min(data$WagesIndustry),"industry"],
                subtitle = "Flop industry: Monthly average wage (CHF)",
                value = round(min(data$WagesIndustry), 0),
                fill=TRUE,
                color="red",
                icon=icon("hand-o-down")
                )
      })
      
      filter_wageindustry <- reactive ({
        filterData_wageindustry <- wage_industry[wage_industry$industry %in% input$indSelector2, ]
        return(filterData_wageindustry)
      })        
      
      output$wage_industry <- renderPlot({
      ggplot(filter_wageindustry(), aes(x= reorder(industry, WagesIndustry), y = WagesIndustry)) +
      geom_bar(aes(fill=Sex), position='dodge', stat = "identity")+
      coord_flip()+
      xlab("Industry")+
      ylab("Montly Wage")    
      })  
      
      output$wage_dedication <- renderPlot({
      wages_1 %>% group_by(taetigk2) %>% 
      summarise(WagesDedication=mean(mbls))  %>% 
      ggplot(aes(x = taetigk2, y = WagesDedication)) +
      geom_bar(stat = "identity")+
      coord_flip()+
      ggtitle("Average wage by dedication")
      })
      
      #Canton
      
      filter_wagecanton <- reactive ({
        filterData_wagecanton <- wage_canton[wage_canton$name %in% input$canSelector, ]
        return(filterData_wagecanton)
      })    
      
      
      output$canton_max <- renderInfoBox({
        data=filter_wagecanton()
        infoBox(title = data[data$values == max(data$values),"name"],
                subtitle = "Top canton: Monthly average wage (CHF)",                
                value = round(max(data$values),0),
                fill=TRUE,
                color="green",
                icon=icon("hand-o-up")
                )
      })      

      output$canton_min <- renderInfoBox({
        data=filter_wagecanton()
        infoBox(title = data[data$values == min(data$values),"name"],
                subtitle = "Flop canton: Monthly average wage (CHF)",                
                value = round(min(data$values),0),
                fill=TRUE,
                color="red",
                icon=icon("hand-o-down")
                )
      })

      output$wage_map <- renderPlot({
      data <- filter_wagecanton()  
      can.plot(data$bfs_nr, data$values, 2016)
      })
      
      output$wage_canton <- renderPlot({
        data <- filter_wagecanton()  
        ggplot(data, aes(x= reorder(name, values), y = values)) +
          geom_bar(stat = "identity", fill="#f05457")+
          coord_flip()+
          xlab("Canton")+
          ylab("Monthly Wage")    
      })  
      
      #Data Table
      output$dt1 <- renderDT({
        datatable(data=wages_data, list(pagelength=5, lengthMenu=c(10,20,30,40)))
      })
      
      output$github <- renderUI({
        tagList("URL link:", urlGithub)
      })
      
      output$linkedin <- renderUI({
        tagList("URL link:", urlLinkedin)
      })
      
})
