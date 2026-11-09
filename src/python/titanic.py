import pandas as pd
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score

print("~~Titanic survival model (Python)~~")

print("\n#13: Load train.csv")
train = pd.read_csv("data/train.csv")
print("Shape:", train.shape)
print(train.head())

print("\n#14: Explore and adjust the data")
print("Missing values:")
print(train.isna().sum())

# fill the missing ages with the median
age_median = train["Age"].median()
train["Age"] = train["Age"].fillna(age_median)
print(f"Filled missing Age with the median ({age_median})")

# change the Sex to numbers
train["Sex"] = train["Sex"].map({"male": 0, "female": 1})
print("Changed Sex to numbers (male = 0, female = 1)")

features = ["Pclass", "Sex", "Age", "SibSp", "Parch", "Fare"]
print("Features I'm using:", features)

X = train[features]
y = train["Survived"]

# test.csv doesn't have Survived, so holding out 20% of train.csv to test
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
print(f"Split train.csv: {len(X_train)} rows to train, {len(X_test)} rows to test")

print("\n#15: Build the logistic regression model")
model = LogisticRegression(max_iter=1000)
model.fit(X_train, y_train)
print("Model trained")

print("\n#16: Accuracy on the training set")
train_acc = accuracy_score(y_train, model.predict(X_train))
print(f"Training accuracy: {train_acc:.4f}")

print("\n#17: Load test.csv and predict")
test = pd.read_csv("data/test.csv")
print("Shape:", test.shape)

test["Age"] = test["Age"].fillna(age_median)
fare_median = train["Fare"].median()
test["Fare"] = test["Fare"].fillna(fare_median)
test["Sex"] = test["Sex"].map({"male": 0, "female": 1})
print("Cleaned test.csv the same way (filled Age and Fare, changed Sex to numbers)")

test_preds = model.predict(test[features])
print("Predicted survivors in test.csv:", test_preds.sum(), "out of", len(test_preds))

print("\n#18: Accuracy on the test set")
test_acc = accuracy_score(y_test, model.predict(X_test))
print(f"Test accuracy (on the 20% held out from train.csv): {test_acc:.4f}")

print("\nTest complete.")