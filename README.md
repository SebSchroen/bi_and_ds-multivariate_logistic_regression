## EDM or Klassik? A Shiny App for Music Genre Classification

This repository contains a Shiny app that utilizes logistic regression to classify songs as either EDM (Electronic Dance Music) or Klassik (Classical) based on their energy and danceability features. 

### App Functionality

*   **Interactive Logistic Regression:** The app allows you to explore the decision boundary of a logistic regression model by adjusting the cutoff probability using a slider. This visualization helps understand how the model classifies songs into different genres based on their features.
*   **Confusion Matrix:** A confusion matrix is displayed, providing insights into the model's performance by showing the number of correct and incorrect predictions for each genre.
*   **Performance Metrics:** The app calculates and presents various performance metrics, including accuracy, recall, precision, and F-measure, to evaluate the effectiveness of the classification model.

### Data and Methodology

The app uses a dataset of songs with features such as energy and danceability. The data is pre-processed and split into training and testing sets. A logistic regression model is trained on the training data to predict the genre (EDM or Klassik) based on the energy and danceability features.

### Libraries Used

*   **shiny:** For creating the interactive web application.
*   **tidyverse:** For data manipulation and visualization.
*   **tidymodels:** For machine learning modeling.
*   **plotly:** For interactive visualizations.

### Running the App

1.  Clone or download this repository.
2.  Ensure you have the required libraries installed in your R environment.
3.  Run the `app.R` file in RStudio or your preferred R environment.
4.  The app will launch in your default web browser, allowing you to interact with the model and explore its predictions. 

### Future Development

*   **Incorporating additional features:** The model could be enhanced by including other relevant song features such as tempo, loudness, and acousticness to improve its predictive power. 
*   **Exploring other classification algorithms:** Experimenting with different machine learning algorithms, such as support vector machines or random forests, could potentially lead to better classification performance.
*   **User-friendly interface enhancements:** The app's interface could be further improved to provide a more intuitive and user-friendly experience. 
