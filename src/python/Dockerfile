# start from a small python image
FROM python:3.11-slim

# folder inside the container where everything goes
WORKDIR /app

# install the packages
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# copy in the script
COPY titanic.py .

# run the script
CMD ["python", "titanic.py"]