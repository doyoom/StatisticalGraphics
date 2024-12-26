library(shiny)
library(DT)
library(plotly)

# 데이터 파일 로드
file_path <- "ahrf2023.csv"
dataset <- read.csv(file_path)

# 숫자형 열만 선택
numeric_columns <- sapply(dataset, is.numeric)
numeric_data <- dataset[, numeric_columns]  # 숫자형 열만 추출

# UI 설정
ui <- navbarPage(
  "AHRF Data Viewer",
  tabPanel(
    "Data Visualization",
    sidebarLayout(
      sidebarPanel(
        sliderInput("range", "Select Range for Data:",
                    min = 1, max = nrow(numeric_data), value = c(1, 100)),
        selectInput("xcol", "X-axis:", choices = colnames(numeric_data)),
        selectInput("ycol", "Y-axis:", choices = colnames(numeric_data))
      ),
      mainPanel(
        plotlyOutput("plot")
      )
    )
  ),
  tabPanel(
    "Raw Data",
    fluidPage(
      DTOutput("data_table")
    )
  )
)

# server 로직
server <- function(input, output) {
  
  # Plotly 그래프 출력
  output$plot <- renderPlotly({
    req(input$xcol, input$ycol)  # X축, Y축 선택
    
    filtered_data <- numeric_data[input$range[1]:input$range[2], ]
    plot_ly(
      data = filtered_data,
      x = ~filtered_data[[input$xcol]],
      y = ~filtered_data[[input$ycol]],
      type = 'scatter',
      mode = 'lines+markers'
    ) %>%
      layout(title = "Interactive Data Visualization",
             xaxis = list(title = input$xcol),
             yaxis = list(title = input$ycol))
  })
  
  # 데이터 테이블 출력
  output$data_table <- renderDT({
    datatable(dataset)
  })
}

# shiny 실행
shinyApp(ui = ui, server = server)
