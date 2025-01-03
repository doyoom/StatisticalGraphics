Component => Selectize (Multiple)  Shiny - Selectize (Multiple)

Layouts => Vertically collapsing accordion panels  Shiny - Tabs



library(shiny)

library(bslib)

library(ggplot2)

library(dplyr)

library(dslabs)



# 데이터 준비

data(murders)

murders <- murders %>%

  mutate(

    population = population / (10^6),  

    murders_per_cap = total / population 

  )



# UI

ui <- page_fillable(

  # Selectize Input: Multiple 선택 가능

  selectizeInput(

    inputId = "select_region",

    label = "Select Regions:",

    choices = unique(murders$region),

    selected = unique(murders$region),

    multiple = TRUE

  ),

  # 아코디언 패널

  navset_tab(

    nav_panel(

      title = "Data Summary",

      accordion(

        accordion_panel(

          "Population",

          plotOutput("populationPlot")

        ),

        accordion_panel(

          "Murders Per Capita",

          plotOutput("murdersPerCapPlot")

        )

      )

    )

  )

)



# Server

server <- function(input, output) {

  # 필터링된 데이터

  filtered_data <- reactive({

    murders %>% filter(region %in% input$select_region)

  })

  

  # Population Plot

  output$populationPlot <- renderPlot({

    ggplot(filtered_data(), aes(x = population, fill = region)) +

      geom_histogram(bins = 10, alpha = 0.7) +

      labs(

        x = "Population (millions)",

        y = "Frequency",

        title = "Population Distribution"

      ) +

      theme_minimal() +

      facet_wrap(~region, scales = "free_y")

  })

  

  # Murders Per Capita Plot

  output$murdersPerCapPlot <- renderPlot({

    ggplot(filtered_data(), aes(x = murders_per_cap, fill = region)) +

      geom_histogram(bins = 10, alpha = 0.7) +

      labs(

        x = "Murders Per Capita",

        y = "Frequency",

        title = "Murders Per Capita Distribution"

      ) +

      theme_minimal() +

      facet_wrap(~region, scales = "free_y")

  })

}



# Shiny App 실행

shinyApp(ui = ui, server = server)

