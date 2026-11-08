import pandas as pd
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score

print("=== Titanic survival model (Python) ===")

# ---------- load the training data ----------
train = pd.read_csv("data/train.csv")
print("\nLoaded train.csv")
print("Shape:", train.shape)
print(train.head())

print("\nMissing values in train:")
print(train.isna().sum())

# ---------- clean / adjust the data ----------
# fill missing ages with the median age
age_median = train["Age"].median()
train["Age"] = train["Age"].fillna(age_median)
print(f"\nFilled missing Age values with the median age ({age_median})")

# turn Sex into a number so the model can use it
train["Sex"] = train["Sex"].map({"male": 0, "female": 1})
print("Converted Sex to numbers (male = 0, female = 1)")

# pick the features to use
features = ["Pclass", "Sex", "Age", "SibSp", "Parch", "Fare"]
print("Using these features:", features)
print("Not using Name, Ticket, Cabin, or Embarked (text / lots of missing values)")

X_train = train[features]
y_train = train["Survived"]

# ---------- build the model ----------
model = LogisticRegression(max_iter=1000)
model.fit(X_train, y_train)
print("\nTrained a logistic regression model")

# accuracy on the training set
train_preds = model.predict(X_train)
train_acc = accuracy_score(y_train, train_preds)
print(f"Training accuracy: {train_acc:.4f}")

# ---------- load the test data ----------
test = pd.read_csv("data/test.csv")
print("\nLoaded test.csv")
print("Shape:", test.shape)

# clean the test data the same way (using the training median for age)
test["Age"] = test["Age"].fillna(age_median)
print(f"Filled missing Age values in test with the training median ({age_median})")

# test has one missing fare, so fill it with the training median fare
fare_median = train["Fare"].median()
test["Fare"] = test["Fare"].fillna(fare_median)
print(f"Filled missing Fare values in test with the training median ({fare_median})")

test["Sex"] = test["Sex"].map({"male": 0, "female": 1})
print("Converted Sex to numbers in test")

# predict on the test set
test_preds = model.predict(test[features])
print("\nMade predictions on the test set")
print("Predicted survivors:", test_preds.sum(), "out of", len(test_preds))

# ---------- test accuracy ----------
# test.csv has no Survived column, so compare against gender_submission.csv
answers = pd.read_csv("data/gender_submission.csv")
test_acc = accuracy_score(answers["Survived"], test_preds)
print(f"Test accuracy (compared to gender_submission.csv): {test_acc:.4f}")
print("Note: gender_submission.csv is Kaggle's example file (all women survive),")
print("not the real answers, so this shows how close we are to that baseline.")

print("\nDone!")