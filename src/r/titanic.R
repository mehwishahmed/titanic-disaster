suppressPackageStartupMessages(library(dplyr))

cat("=== Titanic survival model (R) ===\n")

# ---------- load the training data ----------
train <- read.csv("data/train.csv", na.strings = c("", "NA"))
cat("\nLoaded train.csv\n")
cat("Shape:", nrow(train), "rows,", ncol(train), "columns\n")
print(head(train))

cat("\nMissing values in train:\n")
print(colSums(is.na(train)))

# ---------- clean / adjust the data ----------
age_median <- median(train$Age, na.rm = TRUE)
train <- train %>%
  mutate(Age = ifelse(is.na(Age), age_median, Age))
cat("\nFilled missing Age values with the median age (", age_median, ")\n")

train <- train %>%
  mutate(Sex = ifelse(Sex == "female", 1, 0))
cat("Converted Sex to numbers (male = 0, female = 1)\n")

cat("Using these features: Pclass, Sex, Age, SibSp, Parch, Fare\n")
cat("Not using Name, Ticket, Cabin, or Embarked (text / lots of missing values)\n")

# ---------- build the model ----------
model <- glm(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare,
             data = train, family = binomial)
cat("\nTrained a logistic regression model\n")

# accuracy on the training set (predict survived if probability > 0.5)
train_probs <- predict(model, type = "response")
train_preds <- ifelse(train_probs > 0.5, 1, 0)
train_acc <- mean(train_preds == train$Survived)
cat("Training accuracy:", round(train_acc, 4), "\n")

# ---------- load the test data ----------
test <- read.csv("data/test.csv", na.strings = c("", "NA"))
cat("\nLoaded test.csv\n")
cat("Shape:", nrow(test), "rows,", ncol(test), "columns\n")

# clean the test data the same way (using training medians)
test <- test %>%
  mutate(Age = ifelse(is.na(Age), age_median, Age))
cat("Filled missing Age values in test with the training median (", age_median, ")\n")

fare_median <- median(train$Fare, na.rm = TRUE)
test <- test %>%
  mutate(Fare = ifelse(is.na(Fare), fare_median, Fare))
cat("Filled missing Fare values in test with the training median (", fare_median, ")\n")

test <- test %>%
  mutate(Sex = ifelse(Sex == "female", 1, 0))
cat("Converted Sex to numbers in test\n")

# predict on the test set
test_probs <- predict(model, newdata = test, type = "response")
test_preds <- ifelse(test_probs > 0.5, 1, 0)
cat("\nMade predictions on the test set\n")
cat("Predicted survivors:", sum(test_preds), "out of", length(test_preds), "\n")

# ---------- test accuracy ----------
# test.csv has no Survived column, so compare against gender_submission.csv
answers <- read.csv("data/gender_submission.csv")
test_acc <- mean(test_preds == answers$Survived)
cat("Test accuracy (compared to gender_submission.csv):", round(test_acc, 4), "\n")
cat("Note: gender_submission.csv is Kaggle's example file (all women survive),\n")
cat("not the real answers, so this shows how close we are to that baseline.\n")

cat("\nDone!\n")