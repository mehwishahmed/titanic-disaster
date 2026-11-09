suppressPackageStartupMessages(library(dplyr))

cat("~~Titanic survival model (R)~~\n")

cat("\n#23: Load train.csv\n")
train <- read.csv("data/train.csv", na.strings = c("", "NA"))
cat("Shape:", nrow(train), "rows,", ncol(train), "columns\n")
print(head(train))

cat("\n#24: Explore and adjust the data\n")
cat("Missing values:\n")
print(colSums(is.na(train)))

# fill missing ages with the median
age_median <- median(train$Age, na.rm = TRUE)
train <- train %>% mutate(Age = ifelse(is.na(Age), age_median, Age))
cat("Filled missing Age with the median (", age_median, ")\n")

# change the Sex to numbers
train <- train %>% mutate(Sex = ifelse(Sex == "female", 1, 0))
cat("Changed Sex to numbers (male = 0, female = 1)\n")
cat("Features I'm using: Pclass, Sex, Age, SibSp, Parch, Fare\n")

# test.csv doesn't have Survived, so holding out 20% of train.csv to test
set.seed(42)
train_rows <- sample(nrow(train), size = round(0.8 * nrow(train)))
train_part <- train[train_rows, ]
test_part <- train[-train_rows, ]
cat("Split train.csv:", nrow(train_part), "rows to train,", nrow(test_part), "rows to test\n")

cat("\n#15: Build the logistic regression model\n")
model <- glm(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare,
             data = train_part, family = binomial)
cat("Model trained\n")

cat("\n#16: Accuracy on the training set\n")
train_preds <- ifelse(predict(model, type = "response") > 0.5, 1, 0)
train_acc <- mean(train_preds == train_part$Survived)
cat("Training accuracy:", round(train_acc, 4), "\n")

cat("\n#17: Load test.csv and predict\n")
test <- read.csv("data/test.csv", na.strings = c("", "NA"))
cat("Shape:", nrow(test), "rows,", ncol(test), "columns\n")

fare_median <- median(train$Fare, na.rm = TRUE)
test <- test %>%
  mutate(Age = ifelse(is.na(Age), age_median, Age),
         Fare = ifelse(is.na(Fare), fare_median, Fare),
         Sex = ifelse(Sex == "female", 1, 0))
cat("Cleaned test.csv the same way (filled Age and Fare, changed Sex to numbers)\n")

test_preds <- ifelse(predict(model, newdata = test, type = "response") > 0.5, 1, 0)
cat("Predicted survivors in test.csv:", sum(test_preds), "out of", length(test_preds), "\n")

cat("\n#18: Accuracy on the test set\n")
holdout_preds <- ifelse(predict(model, newdata = test_part, type = "response") > 0.5, 1, 0)
test_acc <- mean(holdout_preds == test_part$Survived)
cat("Test accuracy (on the 20% held out from train.csv):", round(test_acc, 4), "\n")

cat("\nTest complete.\n")