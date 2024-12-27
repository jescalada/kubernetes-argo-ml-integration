# kubernetes-argo-ml-integration
Demo for integrating Kubernetes and ArgoCD with a ML model.

## How to run the demo
1. Run `python model_training.py` to train the model.
- This will create a model directory with the trained model, which will be used by the prediction service.
2. Run `docker build -t my-tf-model:latest .` to build the Docker image.
3. Run `docker run -p 8501:8501 my-tf-model:latest` to run the Docker container based on the image. This will start a TensorFlow Serving server to easily use the model.

You can test the model as follows. Note that this will take a while the first time you run it, as the model is being loaded into memory.

## Unix-based systems
```bash
curl -X POST http://localhost:8501/v1/models/my_model:predict -d '{"instances": [[0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]]}'
```

## Windows
```powershell
Invoke-WebRequest -Uri http://localhost:8501/v1/models/my_model:predict -Method POST -Body '{"instances": [[0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]]}' -ContentType "application/json"
```

## How to deploy the model to Kubernetes
Work in progress.