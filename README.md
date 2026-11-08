# Titanic Survival Prediction (Python + R with Docker)

This repo builds a logistic regression model that predicts which passengers survived the Titanic. There are two versions, one in **Python** and one in **R**, and each runs inside its own **Docker** container. Each script loads the data, cleans it, trains the model, and prints the training and test accuracy to the terminal.

The dataset is **not** included in this repo, so you'll need to download it first (step 2 below).

---

## What you need first

- **Docker Desktop**, installed and running (download it from https://www.docker.com/products/docker-desktop/)
- **Git** (to clone the repo)
- A free **Kaggle** account (to download the data)

---

## Step 1: Clone the repo

Open a terminal and run:

```bash
git clone https://github.com/mehwishahmed/titanic-disaster.git
cd titanic-disaster
```

All the commands below should be run from inside this `titanic-disaster` folder.

---

## Step 2: Download the data

1. Go to https://www.kaggle.com/competitions/titanic/data (you may need to log in and click **Join Competition** / accept the rules first).
2. Download these three files:
   - `train.csv`
   - `test.csv`
   - `gender_submission.csv`
3. Create the data folder (it isn't included in the repo):

   ```bash
   mkdir -p src/data
   ```

4. Move the three CSV files into `src/data/`.

Your folder should look like this:

```
titanic-disaster/
├── README.md
├── .gitignore
└── src/
    ├── data/
    │   ├── train.csv
    │   ├── test.csv
    │   └── gender_submission.csv
    ├── python/
    │   ├── Dockerfile
    │   ├── requirements.txt
    │   └── titanic.py
    └── r/
        ├── Dockerfile
        ├── install_packages.R
        └── titanic.R
```

---

## Step 3: Run the Python version

Make sure Docker Desktop is open, then run these two commands:

```bash
docker build -t titanic-python src/python
docker run --rm -v "$(pwd)/src/data:/app/data" titanic-python
```

- The first command builds the Docker image and installs the packages from `requirements.txt` (pandas, numpy, scikit-learn).
- The second command runs the script. The `-v` part connects your `src/data` folder to the container so the script can read the CSV files.

---

## Step 4: Run the R version

```bash
docker build -t titanic-r src/r
docker run --rm -v "$(pwd)/src/data:/app/data" titanic-r
```

The first build takes a few minutes because it downloads R and installs `dplyr` (from `install_packages.R`). After the first time, it's much faster.

---

## What you should see

Both versions print each step to the terminal:

1. Loading `train.csv` and showing its shape, first rows, and missing values
2. The cleaning steps (filling missing Age with the median, converting Sex to numbers)
3. The features used for the model: `Pclass`, `Sex`, `Age`, `SibSp`, `Parch`, `Fare`
4. **Training accuracy** (about 0.79–0.80)
5. Loading `test.csv`, cleaning it the same way (including filling one missing Fare), and making predictions
6. **Test accuracy** (about 0.94)
7. `Done!`

### Note about the test accuracy

`test.csv` doesn't include the `Survived` column, since Kaggle keeps the real answers private. To still measure test accuracy, the scripts compare predictions to `gender_submission.csv`, which is Kaggle's example file that predicts all women survive and all men don't. So the test accuracy shows how closely the model matches that baseline, not its accuracy on the true answers.

---

## Windows users

`$(pwd)` works on Mac and Linux. On Windows, replace it in the `docker run` commands:

- **PowerShell:** use `${PWD}` → `docker run --rm -v "${PWD}/src/data:/app/data" titanic-python`
- **Command Prompt:** use `%cd%` → `docker run --rm -v "%cd%/src/data:/app/data" titanic-python`

(Same for `titanic-r`.)

---

## Troubleshooting

- **"Cannot connect to the Docker daemon":** Docker Desktop isn't running. Open it and wait for it to finish starting.
- **"No such file or directory: data/train.csv":** the CSVs aren't in `src/data/`, or you're not running the command from the `titanic-disaster` folder. Check with `ls src/data`.