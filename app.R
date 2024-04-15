library(shiny)
library(dplyr)
library(readr)
library(tidymodels)


# Load data (assuming it's in a file named 'songs_with_features.csv')
data <- read_csv("rawdata/songs_with_features.csv") %>% 
  filter(category %in% c("Klassik", "Dance/Electronic")) %>% 
  select(track.name, track.artist, category, energy, danceability) %>% 
  mutate(category = case_when(
    category == "Klassik" ~ "Klassik",
    category == "Dance/Electronic" ~ "EDM"
  ))

# Split data (same seed as before for reproducibility)
set.seed(1)
split <- initial_split(data, prop = 3*0.029156, strata = category)
training <- 
  training(split) %>% 
  select(category, energy, danceability, track.name, track.artist) %>% 
  mutate(edm = case_when(
    category == "EDM" ~ 1,
    category == "Klassik" ~ 0
  )) %>% 
  mutate(edm_factor = as.factor(edm))

# Define UI
ui <- fluidPage(
  titlePanel("Multivariate Logistic Explorer"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("C", "Cutoff Probability:", min = 0.01, max = 0.99, value = 0.5, step = 0.01),
      tableOutput("metrics")
    ),
    mainPanel(
      plotOutput("plot"),
      plotOutput("confusion_matrix")
      
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  # Reactive expression to update predictions based on C
  predictions <- reactive({
    logistic <- logistic_reg() %>%
      set_engine("glm") %>%
      fit(edm_factor ~ energy + danceability, data = training)
    
    augment(logistic, new_data = training, .predict = "response") %>% 
      mutate(.pred_class = if_else(.pred_1 > input$C, 1, 0)) %>% 
      mutate(.pred_class = as.factor(.pred_class))
  })
  
  # Generate Plot
  output$plot <- renderPlot({
    coefs <- tidy(logistic_reg() %>%
                    set_engine("glm") %>%
                    fit(edm_factor ~ energy + danceability, data = training)) %>% 
      pull(estimate)
    slope <- coefs[2]/(-coefs[3])
    intercept <- (log(input$C/(1-input$C))-coefs[1])/(coefs[3]) 
    
    predictions() %>% 
      ggplot(aes(x = energy, y = danceability, shape = .pred_class, color = edm_factor)) +
      geom_point(size = 3) +
      labs(x = "Energy", y = "Danceability", shape = "Prediction", color = "Genre") +
      xlim(0,1) + ylim(0,1) +
      geom_abline(slope = slope, intercept = intercept, linetype = "dashed") +
      ggtitle("Predictions from Multiple Logistic Regression") + 
      theme_minimal()
    
  })
  
  # Generate Confusion Matrix
  output$confusion_matrix <- renderPlot({
    yardstick::conf_mat(predictions(), truth = edm_factor, estimate = .pred_class) %>% 
      autoplot("heatmap")
  })
  
  # Generate Metrics Table
  output$metrics <- renderTable({
    multi_metric <- metric_set(yardstick::accuracy, recall, precision, f_meas)
    predictions() %>% 
      multi_metric(truth = edm_factor, estimate = .pred_class, event_level = "second") %>%
      select(.metric, .estimate) %>%
      rename(Metric = .metric, Value = .estimate)  %>% 
      mutate(Value = as.character(round(Value, 4)))
  })
}

# Run the app
shinyApp(ui = ui, server = server)