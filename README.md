# Credit Score Prediction & Cloud Deployment

An end-to-end machine learning and MLOps project for classifying customer credit scores and deploying the trained model to AWS.

The project covers exploratory data analysis, data preprocessing, model comparison, hyperparameter tuning, MLflow experiment tracking, local inference, and cloud deployment using AWS SageMaker and Streamlit.

## Project Overview

The objective of this project is to classify a customer's credit score into one of three categories:

- Good
- Standard
- Poor

The machine learning workflow starts from raw financial and credit-related customer data and continues through preprocessing, model development, experiment tracking, evaluation, and deployment.

The dataset contains approximately **25,000 records and 29 raw columns**.

## Machine Learning Workflow

The project follows an end-to-end workflow:

1. Data ingestion
2. Exploratory Data Analysis
3. Data cleaning
4. Feature preprocessing
5. Train-test split
6. Baseline model comparison
7. Hyperparameter tuning
8. Model evaluation
9. MLflow experiment tracking
10. Model serialization
11. Local Streamlit inference
12. AWS SageMaker deployment
13. Cloud-based prediction through a Streamlit interface

## Data Preprocessing

Several preprocessing steps are applied before model training.

### Data Cleaning

Unnecessary identifier columns are removed, including:

- ID
- Customer ID
- Customer Name
- SSN

Numerical fields stored as strings are converted into numerical values.

Invalid and missing values are also handled during preprocessing.

### Feature Transformation

Numerical features are standardized using:

```text
StandardScaler
```

Categorical features are encoded using:

```text
OneHotEncoder
```

The preprocessing steps and machine learning model are combined using a Scikit-learn `Pipeline`.

## Models

Four machine learning approaches were evaluated:

- Logistic Regression
- Decision Tree
- Random Forest
- Extra Trees Classifier

### Model Comparison

| Model | Accuracy | Weighted Precision | Weighted Recall | Weighted F1 |
|---|---:|---:|---:|---:|
| Logistic Regression | 69.58% | 69.74% | 69.58% | 69.47% |
| Decision Tree | 65.46% | 65.43% | 65.46% | 65.44% |
| Random Forest | 71.72% | 71.95% | 71.72% | 71.77% |
| **Tuned Extra Trees** | **73.98%** | **74.08%** | **73.98%** | **74.01%** |

The tuned Extra Trees model achieved the strongest overall performance and was selected as the final model.

## Hyperparameter Tuning

After evaluating the baseline models, Extra Trees was optimized using:

```text
RandomizedSearchCV
```

The search used:

- 25 parameter combinations
- 3-fold cross-validation
- Weighted F1-score as the optimization metric

Weighted F1-score was selected because the credit score classes are not perfectly balanced.

The best cross-validation weighted F1-score was approximately:

```text
0.7278
```

The selected Extra Trees configuration included:

```text
n_estimators = 200
max_depth = 50
min_samples_split = 5
min_samples_leaf = 1
max_features = None
criterion = entropy
bootstrap = False
```

## Final Model

The final model is an **Extra Trees Classifier** integrated with the complete preprocessing pipeline.

Final test performance:

```text
Accuracy:  0.7398
Precision: 0.7408
Recall:    0.7398
F1 Score:  0.7401
```

The complete preprocessing and model pipeline is stored as:

```text
best_credit_score_model.pkl
```

## MLflow Experiment Tracking

MLflow is used to track machine learning experiments.

For each model, the project records:

- Model parameters
- Accuracy
- Precision
- Recall
- Weighted F1-score
- Classification report
- Trained Scikit-learn pipeline

This makes it easier to compare experiments and identify the best-performing model.

## AWS Deployment Architecture

The final model can also be deployed to AWS.

```text
Customer Input
      │
      ▼
Streamlit Application
      │
      ▼
Boto3 / SageMaker Runtime
      │
      ▼
AWS SageMaker Endpoint
      │
      ▼
Preprocessing + Extra Trees Model
      │
      ▼
Prediction & Class Probabilities
      │
      ▼
Streamlit Result
```

### AWS Services

The cloud implementation uses:

**Amazon SageMaker**

Hosts the trained machine learning model and provides a real-time inference endpoint.

**Amazon S3**

Stores the packaged model artifact before SageMaker deployment.

**Amazon EC2**

Can be used to host the Streamlit application.

**Boto3**

Allows the Python application to communicate with the SageMaker endpoint.

## Local and Cloud Applications

### Local Application

`app.py` provides a Streamlit interface that loads the trained model locally and performs credit score prediction.

### Cloud Application

`aws/app_cloud.py` provides a Streamlit interface connected to the deployed SageMaker endpoint.

The application sends customer information to SageMaker and displays:

- Predicted credit score
- Prediction probabilities for each class

## Project Structure

```text
credit-score-aws-deployment/
│
├── 1_CreditScore_EDA_Modelling.ipynb
├── app.py
├── best_credit_score_model.pkl
├── data_B.csv
├── data_ingestion.py
├── evaluation.py
├── get_test_cases.py
├── inference.py
├── model_comparison.csv
├── preprocessing.py
├── requirements.txt
├── test_cases.csv
├── training.py
├── train_pipeline.py
├── .gitignore
│
└── aws/
    ├── app_cloud.py
    ├── cloud_inference.py
    ├── deploy_endpoint.py
    ├── inference_sagemaker.py
    └── user-data.sh
```

## File Description

`1_CreditScore_EDA_Modelling.ipynb`  
Contains exploratory data analysis, preprocessing experiments, baseline modeling, hyperparameter tuning, and model evaluation.

`data_ingestion.py`  
Handles data loading and creates the raw-data directory used by the training workflow.

`preprocessing.py`  
Handles data cleaning, numerical conversion, missing values, scaling, and categorical encoding.

`training.py`  
Trains multiple classification algorithms and tracks experiments with MLflow.

`evaluation.py`  
Calculates classification metrics, classification reports, and confusion matrices.

`train_pipeline.py`  
Runs the complete training workflow from data ingestion to final model serialization.

`model_comparison.csv`  
Stores the performance comparison between the evaluated models.

`inference.py`  
Provides local model inference functionality.

`get_test_cases.py`  
Generates test cases for model prediction.

`app.py`  
Provides the local Streamlit prediction interface.

`aws/deploy_endpoint.py`  
Packages the trained model, uploads the model artifact to S3, and deploys it to a SageMaker endpoint.

`aws/inference_sagemaker.py`  
Defines how SageMaker loads the model, processes incoming requests, performs predictions, and returns responses.

`aws/cloud_inference.py`  
Communicates with the SageMaker endpoint using Boto3.

`aws/app_cloud.py`  
Provides the cloud-connected Streamlit user interface.

`aws/user-data.sh`  
Provides an EC2 startup script for setting up and running the Streamlit application.

## Running the Project Locally

### 1. Clone the Repository

```bash
git clone https://github.com/syaqillanajwa25-ops/credit-score-aws-deployment.git
cd credit-score-aws-deployment
```

### 2. Install Dependencies

```bash
pip install -r requirements.txt
```

### 3. Train the Models

```bash
python train_pipeline.py
```

This process performs:

```text
Data Ingestion
      ↓
Data Cleaning
      ↓
Preprocessing
      ↓
Model Training
      ↓
MLflow Tracking
      ↓
Model Comparison
      ↓
Best Model Evaluation
      ↓
Model Serialization
```

### 4. Run the Local Streamlit Application

```bash
streamlit run app.py
```

## MLflow

To view the experiment tracking interface:

```bash
mlflow ui --backend-store-uri sqlite:///mlflow.db
```

Then open:

```text
http://127.0.0.1:5000
```

## AWS Deployment

The AWS deployment files are located inside:

```text
aws/
```

The cloud application expects the SageMaker endpoint configuration through environment variables.

Example:

```bash
export SAGEMAKER_ENDPOINT_NAME="your-sagemaker-endpoint"
export AWS_REGION="us-east-1"
```

The model can then be accessed through the cloud Streamlit application.

```bash
streamlit run aws/app_cloud.py
```

> AWS credentials and an active SageMaker endpoint are required for cloud inference.

## Tech Stack

### Data Science & Machine Learning

- Python
- Pandas
- NumPy
- Scikit-learn
- Logistic Regression
- Decision Tree
- Random Forest
- Extra Trees
- RandomizedSearchCV

### MLOps

- MLflow
- Joblib
- Scikit-learn Pipeline

### Application

- Streamlit

### Cloud

- AWS SageMaker
- Amazon S3
- Amazon EC2
- Boto3

### Visualization & Development

- Matplotlib
- Seaborn
- Jupyter Notebook

## Key Features

- End-to-end machine learning pipeline
- Credit score multiclass classification
- Automated preprocessing pipeline
- Multiple model comparison
- Hyperparameter tuning with RandomizedSearchCV
- MLflow experiment tracking
- Weighted F1-based model selection
- Local Streamlit application
- Model serialization for inference
- AWS SageMaker real-time endpoint deployment
- Cloud prediction using Boto3
- Prediction probability output

## Future Improvements

Possible improvements include:

- Compare additional boosting algorithms such as XGBoost and LightGBM
- Add SHAP-based model explainability
- Add automated model monitoring
- Add data and model versioning
- Implement CI/CD for model deployment
- Containerize the application using Docker
- Add automated testing
- Improve cloud infrastructure automation
