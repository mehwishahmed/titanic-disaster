# MLDS 400 - Titanic Survival Prediction (Python + R with Docker)

This repo builds a logistic regression model that predicts the survival of passengers from the Titanic. There are two versions of these models: one is in **Python** and the other one in **R**. Each of these run inside its own **Docker** container. The basic breakdown of each script is that it loads the data, cleans it, trains the model, and finally, prints the training and test accuracy to the terminal.

Note: since the datasets are **not** included in this repo, you will need to download them first before proceeding (detailed in step 2 below).

------

## What you need

- **Docker Desktop** installed and running
- **Git** to clone the repo
- **Kaggle** account to download the data

------

## Step 1: Clone the repo

Open up terminal on your machine and run:

```bash
git clone https://github.com/mehwishahmed/titanic-disaster.git
cd titanic-disaster
```

(Keep in mind: All commands in terminal should be run from inside the `titanic-disaster` folder.)

------

## Step 2: Download the data

1. Go to https://www.kaggle.com/competitions/titanic/data (you need to log in/create an account for this).

2. Download these two files in this competition:
   - `train.csv`
   - `test.csv`

3. Create the data folder (this isn't included in the repo):

   ```bash
   mkdir -p src/data
   ```

4. Move the two CSV files into `src/data/`.

So now, the folder should look like this:

```
titanic-disaster/
├── README.md
├── .gitignore
└── src/
    ├── data/
    │   ├── train.csv
    │   └── test.csv
    ├── python/
    │   ├── Dockerfile
    │   ├── requirements.txt
    │   └── titanic.py
    └── r/
        ├── Dockerfile
        ├── install_packages.R
        └── titanic.R
```

------

## Step 3: Run the Python file

Ensure Docker Desktop is open, then run these commands in terminal:

```bash
docker build -t titanic-python src/python
docker run --rm -v "$(pwd)/src/data:/app/data" titanic-python
```

What's happening here:
- The first command is building the Docker image and installing the `requirements.txt` packages.
- The second command runs the script. In particular, the `-v` is what connects the `src/data` folder to the container so that the script can read the CSV files.

------

## Step 4: Run the R file

Now, we will run the R file. Locate to src/r/titanic.R for reference and run the following commands in terminal:

```bash
docker build -t titanic-r src/r
docker run --rm -v "$(pwd)/src/data:/app/data" titanic-r
```

The first command, which builds the Docker image, will take a couple minutes time because it initiates the download of R and installs `dplyr` from `install_packages.R` for the first time. However, after the first time it's much faster.

------

## What you should see after running both files

Both versions have print statements of each step in the terminal:

1. Loading `train.csv` and showing its general shape, first rows, and missing values.
2. The cleaning steps (includes filling missing Age with the median, converting Sex to numbers).
3. The features used for the model: `Pclass`, `Sex`, `Age`, `SibSp`, `Parch`, `Fare`.
4. **Training accuracy** (around 0.80).
5. Loading `test.csv`, cleaning it the same way as train.csv, and making predictions.
6. **Test accuracy** (about 0.81 in Python, 0.75 in R).
7. Print `Test complete` as an indication to finish.

### Note about the test accuracy

test.csv doesn't have the Survived column, so I couldn't check accuracy on it directly. Instead I split train.csv 80/20 and used the 20% as my test set. The models make predictions on test.csv.

## If on Windows

If a Windows user, here are steps to running this in terminal:

`$(pwd)` works on Mac/Linux. On Windows PowerShell, use `${PWD}`

```bash
docker run --rm -v "${PWD}/src/data:/app/data" titanic-python
```

(Do the same thing for titanic-r.)

## Troubleshooting:

- If Docker says it can't connect -> Docker Desktop probably isn't open.
- It can't find train.csv or test.csv: make sure the files are in `src/data/` and you're running the commands from the `titanic-disaster` folder.