
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Ceiling effects and criteria validity"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("celing",
                  "Test ceiling:",
                  min = 0,
                  max = 200,
                  value = 120),
      sliderInput("floor",
                  "Test floor:",
                  min = 0,
                  max = 200,
                  value = 80),
      sliderInput("cor",
                  "Correlation with criteria variable in population:",
                  min = 0,
                  max = 1,
                  value = .5,
                  step = .01),
      actionButton("update", "Update!")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      HTML("<p>Ceiling effects are when we try to measure something and our measurement instrument does not have sufficient range at the right tail. If it is a test, it is said to be too easy. A floor effect is the same just at the left tail instead; the test is too hard.</p>",
"<p>The first figure below shows a histogram of scores from a population with a mean of 100 and a standard deviation of 15. When there is a ceiling/floor, the scores will tend to pile up at the ends of our scales. The scores that would have been higher/lower are shown in green/blue below and those in the captured region are shown in red.</p>",
"<p>In relation to predicting the performance on some criteria variable, the effect is to slightly lower the correlation. The mean score can go up or down, depending on whether the celing or floor effect is strongest. The standard deviation is reduced in the presence of any ceiling/floor effect. The second figure below shows the scatter plot of the test scores and scores on a criteria variable.</p>",
"<p>Try playing around with the sliders on the left to see how things change.</p>"),
      plotOutput("plot1"),
      plotOutput("plot2"),
      HTML("Made by <a href='http://emilkirkegaard.dk'>Emil O. W. Kirkegaard</a> using <a href='http://shiny.rstudio.com/'/>Shiny</a> for <a href='http://en.wikipedia.org/wiki/R_%28programming_language%29'>R</a>. Source code available on <a href='https://github.com/Deleetdk/ceiling_effects'>Github</a>.")
    )
  )
  )
)
