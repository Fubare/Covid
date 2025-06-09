#-----Section 01-------------------------------------------

# set working directory
setwd(dirname(file.choose()))
getwd()

# read in data from csv file
Covid <- read.csv("Combined_data.csv", stringsAsFactors = FALSE)
head(Covid)
str(Covid)

# select dependent and independent variables
Covid_1 <- data.frame(Covid$Total_deaths,Covid$Asian, Covid$Black, Covid$Mixed, Covid$White, Covid$Other_ethnics, Covid$No_religion, Covid$Christian,
                      Covid$Buddhist, Covid$Hindu, Covid$Jewish, Covid$Muslim, Covid$Sikh, Covid$No_answer,
                      Covid$No_qualifications, Covid$Level1_entry_level_qualifications, Covid$Level2_qualifications,
                      Covid$Apprenticeship, Covid$Level3_qualifications, Covid$Level4_qualifications_above, Covid$Remote_jobs,
                      Covid$Underground_metro_light.rail_tram, Covid$Train, Covid$Bus_minibus_coach, Covid$Taxi,
                      Covid$Motorcycle_scooter_moped, Covid$Driving, Covid$Passenger_in_a_car_van, Covid$Bicycle,
                      Covid$On_foot, Covid$Other_methods, Covid$Children, Covid$Pre_Teens, Covid$Teenagers, Covid$Adults,
                      Covid$Middle_Aged, Covid$Elderly)

# Rename columns
colnames(Covid_1) <- c('Total_deaths', 'Asian', 'Black', 'Mixed', 'White', 'Other_ethnics', 'No_religion', 'Christian', 'Buddhist', 'Hindu', 'Jewish', 'Muslim', 'Sikh', 'No_answer',
                       'No_qualifications', 'Level1_entry_level_qualifications', 'Level2_qualifications', 'Apprenticeship', 'Level3_qualifications',
                       'Level4_qualifications_above', 'Remote_jobs', 'Underground_metro_light_rail_tram', 'Train', 'Bus_minibus_coach', 'Taxi',
                       'Motorcycle_scooter_moped', 'Driving', 'Passenger_in_a_car_van', 'Bicycle', 'On_foot', 'Other_methods',
                       'Children', 'Pre_Teens', 'Teenagers', 'Adults', 'Middle_Aged', 'Elderly')

# Generate plots and save to working directory

library(ggplot2)
library(car)

for (var in colnames(Covid_1)) {
  # Histogram with density curve
  png(paste0(var, "_histogram_density.png"))
  hist(
    Covid_1[[var]],
    main = paste("Histogram of", var),
    xlab = var,
    col = "lightblue",
    border = "black",
    prob = TRUE # This scales the histogram to show density
  )
  
  # Add density curve
  lines(
    density(Covid_1[[var]], na.rm = TRUE),
    col = "red",
    lwd = 2
  )
  dev.off()
  
  # Box Plot
  png(paste0(var, "_boxplot.png"))
  boxplot(Covid_1[[var]], main = paste("Box Plot of", var), ylab = var, col = "lightgreen")
  dev.off()
  
  # Q-Q Plot
  png(paste0(var, "_qqplot.png"))
  qqPlot(Covid_1[[var]], main = paste("Q-Q Plot of", var), col = "blue")
  dev.off()
}

# Store p-values for tests
ks_results <- numeric()
sw_results <- numeric()
variables <- colnames(Covid_1)

for (var in variables) {
  data <- Covid_1[[var]]
  
  # Kolmogorov-Smirnov Test
  ks_test <- ks.test(data, "pnorm", mean(data, na.rm = TRUE), sd(data, na.rm = TRUE))
  ks_results <- c(ks_results, ks_test$p.value)
  
  # Shapiro-Wilk Test
  sw_test <- shapiro.test(data)
  sw_results <- c(sw_results, sw_test$p.value)
}

# Combine results into a data frame
results_table <- data.frame(
  Variable = variables,
  KS_p_value = ks_results,
  KS_Normal = ifelse(ks_results > 0.05, "Yes", "No"),
  SW_p_value = sw_results,
  SW_Normal = ifelse(sw_results > 0.05, "Yes", "No")
)

# Print the results table
print(results_table)

# Create a dataframe for storing results
Covid_2 <- data.frame(Variable = character(), Correlation = numeric(), stringsAsFactors = FALSE)

# Define dependent variable
dependent_var <- Covid$Total_deaths

# Get the list of independent variables
independent_vars <- names(Covid_1)

# Loop through each independent variable
for (var in independent_vars) {
  # Extract the independent variable
  independent_var <- Covid_1[[var]]
  
  # Calculate Spearman's correlation
  correlation <- cor(dependent_var, independent_var, method = "spearman", use = "complete.obs")
  
  # Append results to the dataframe
  Covid_2 <- rbind(Covid_2, data.frame(Variable = var, Correlation = correlation))
}

print(Covid_2)

# Filter variables based on correlation greater than 0.2
filtered <- Covid_2[Covid_2$Correlation > 0.2 | Covid_2$Correlation < -0.2, ]

# Print the filtered results
print(filtered)

library(corrplot)

# Compute correlation matrix including the dependent variable
cor_matrix <- cor(Covid_1, use = "complete.obs", method = "spearman")
corrplot(cor_matrix,
         method = "color",
         type = "upper",
         tl.col = "black",
         tl.srt = 120,           # Vertical text labels (changed from 45)
         addCoef.col = "black",
         number.cex = 0.4,      # Smaller numbers
         tl.cex = 0.7,         # Smaller label text
         cl.cex = 0.8,         # Legend text size
         mar = c(1,0,1,0),     # Adjusted margins
         diag = FALSE,         # Don't show diagonal
         tl.offset = 0.5,      # Offset text labels
         col = colorRampPalette(c("blue", "white", "red"))(200)
)

dev.new()
corrplot(cor_matrix)
library(psych)  
library(factoextra)  

# Subset the data for selected variables
pca_data <- Covid[, c("Remote_jobs", "Taxi", "Bicycle", "Children", "Pre_Teens")]
# Ensure there are no missing values
pca_data <- na.omit(pca_data)

# KMO Test
kmo_test <- KMO(pca_data)
print(kmo_test)

# Compute Eigenvalues
eigen_values <- eigen(cor(pca_data))$values
print(eigen_values)

# Scree Plot
fviz_eig(prcomp(pca_data, scale. = TRUE), addlabels = TRUE, ylim = c(0, max(eigen_values) + 1))

# Cumulative Scree Plot
cumulative_variance <- cumsum(eigen_values / sum(eigen_values))
plot(cumulative_variance, type = "b", xlab = "Number of Factors", ylab = "Cumulative Variance Explained",
     main = "Cumulative Scree Plot", ylim = c(0, 1))

abline(h = 0.8, col = "red", lty = 2)  # 80% variance cutoff
abline(h = 0.9, col = "red", lty = 2)  # 90% variance cutoff
abline(h = 0.95, col = "red", lty = 2)  # 95% variance cutoff

# Perform PCA (Varimax Rotation) with 4 Factors
pca_results <- principal(pca_data, nfactors = 4, rotate = "varimax", scores = TRUE)

# Print PCA Output
print(pca_results)

# Subset the data for independent variables (same as PCA variables)
regression_data <- Covid[, c("Remote_jobs", "Taxi", "Bicycle", "Children")]

# Ensure there are no missing values
regression_data <- na.omit(regression_data)

# Combine the dependent variable with the independent variables
final_data <- data.frame(dependent_var, regression_data)

# Fit the multiple linear regression model
model <- lm(dependent_var ~ ., data = final_data)

# Print the model summary
summary(model)

# Check for multicollinearity using VIF (Variance Inflation Factor)
vif_values <- vif(model)
print(vif_values)
sqrt(vif(model)) > 2  # if > 2 vif too high

# Subset the data for independent variables
regression_data_1 <- Covid[, c("Remote_jobs", "Taxi", "Bicycle", "Children")]

# Ensure there are no missing values
regression_data_1 <- na.omit(regression_data_1)

# Combine the dependent variable with the independent variables
final_data <- data.frame(dependent_var, regression_data_1)

# Fit the multiple linear regression model
model_1 <- lm(dependent_var ~ ., data = final_data)

# Print the model summary
summary(model_1)

plot(model_1)
# Check for multicollinearity using VIF (Variance Inflation Factor)
vif_values <- vif(model_1)
print (vif_values)
sqrt(vif(model_1)) > 2  # if > 2 vif too high

#rm(list=ls())
