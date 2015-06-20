
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)
library(grid)
library(MASS)
library(psych)
library(stringr)

n = 100000

shinyServer(function(input, output) {
  
  reac_data = reactive({
    #update
    input$update
    #this is to avoid spamming the server with generate data requests
    
    isolate({
      #generate data
      set.seed(1)
      r = input$cor
      d = mvrnorm(n, c(0, 0), matrix(c(1, r, r, 1), nrow = 2), empirical = F)
      d = as.data.frame(d)
      colnames(d) = c("X", "Y")
      
      #rescale
      d$X = d$X * 15 + 100
      d$Y = d$Y * 10 + 60
      
      #add mor
      d$group = rep("Within limits", n)
      
      #ceiling
      above.ceiling = d$X > input$celing
      d[above.ceiling, "X"] = input$celing - 0.000001
      d[above.ceiling, "group"] = "Above ceiling"
      
      #floor
      below.ceiling = d$X < input$floor
      d[below.ceiling, "X"] = input$floor + 0.000001
      d[below.ceiling, "group"] = "Below ceiling"
      
      #fix levels
      d$group = factor(d$group, levels = c("Within limits", "Above ceiling", "Below ceiling") )
    })
    
    
    return(d)
  })

  output$plot1 <- renderPlot({
    #data
    d = reac_data()
    
    #summary
    s = describe(d$X)
    
    #text
    t = str_c("Mean score: ", round(s$mean, 2),
              "\nStandard deviation: ", round(s$sd, 3))
    
    t_object = grobTree(textGrob(t, x=.5,  y=.33), #text position
                                 gp = gpar(fontsize=11)) #text size
    
    ggplot(d, aes(X)) +
      geom_bar(aes(fill = group, y = ((..count..)/sum(..count..)) ), binwidth = 2) +
      #geom_density() +
      xlab("Test score") + ylab("Density") +
      scale_fill_discrete(breaks = levels(d$group),
                          labels = levels(d$group)) +
      annotation_custom(t_object)
  })
  
  output$plot2 = renderPlot({
    #fetch data
    d = reac_data()
    
    #text
    t = str_c("Correlation in sample: ", round(cor(d$X, d$Y), 3))
    
    t_object = grobTree(textGrob(t, x = .05,  y = .95, hjust = 0), #text position
                        gp = gpar(fontsize = 11)) #text size
    
    #plot
    ggplot(d, aes(X, Y)) +
      geom_point(aes(color = group), alpha = .5) +
      geom_smooth(method = "lm", se = F) +
      annotation_custom(t_object)
  })

})
