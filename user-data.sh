#!/bin/bash
set -eux

sudo yum update -y
sudo yum install -y git python3 python3-pip

REPO_URL="https://github.com/syaqillanajwa25-ops/credit-score-aws-deployment.git"
PROJECT_DIR="/home/ec2-user/SageMaker/credit-score-aws-deployment"

mkdir -p /home/ec2-user/SageMaker

if [ ! -d "$PROJECT_DIR/.git" ]; then
    rm -rf "$PROJECT_DIR"
    git clone "$REPO_URL" "$PROJECT_DIR"
else
    cd "$PROJECT_DIR"
    git pull
fi

cd "$PROJECT_DIR"

python3 -m pip install --upgrade pip
python3 -m pip install -r requirements.txt || true
python3 -m pip install streamlit boto3 pandas numpy scikit-learn joblib mlflow sagemaker

pkill -f streamlit || true

nohup python3 -m streamlit run app_cloud.py \
  --server.port 8501 \
  --server.address 0.0.0.0 \
  --server.headless true \
  --browser.gatherUsageStats false \
  > "$PROJECT_DIR/streamlit.log" 2>&1 &

chown -R ec2-user:ec2-user /home/ec2-user/SageMaker
