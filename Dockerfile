# Use the TensorFlow Serving image as a base
FROM tensorflow/serving:latest

# Copy the model into the expected directory for TensorFlow Serving
COPY model/ /models/my_model/1/

# Set the environment variables
ENV MODEL_NAME=my_model

# Expose the default TensorFlow Serving port
EXPOSE 8501
