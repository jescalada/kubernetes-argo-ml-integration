FROM python:3.9-slim

# Copy your application code
WORKDIR /app
COPY . .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Run your application (if needed)
CMD ["python", "model_training.py"]
