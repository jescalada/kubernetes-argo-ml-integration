# kubernetes-argo-ml-integration
Demo for integrating Kubernetes and ArgoCD with a ML model.

## How to run the demo
Running the demo requires Docker and Kubernetes. First, we need to set the prediction service in a Docker container. Then, we can deploy the model to Kubernetes.

## Setting up Docker
1. Run `python model_training.py` to train the model.
- This will create a model directory with the trained model, which will be used by the prediction service.
2. Run `docker build -t my-tf-model:latest .` to build the Docker image.
3. Run `docker run -p 8501:8501 my-tf-model:latest` to run the Docker container based on the image. This will start a TensorFlow Serving server to easily use the model.

You can test the model as follows. Note that this will take a while the first time you run it, as the model is being loaded into memory.

### Unix-based systems
```bash
curl -X POST http://localhost:8501/v1/models/my_model:predict -d '{"instances": [[0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]]}'
```

### Windows
```powershell
Invoke-WebRequest -Uri http://localhost:8501/v1/models/my_model:predict -Method POST -Body '{"instances": [[0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]]}' -ContentType "application/json"
```

## Setting up the Kubernetes deployment
1. Push the Docker Image to a container registry such as Docker Hub. This example uses Docker Hub. You must have a Docker Hub account and be logged in.
```bash
docker tag my-tf-model:latest <your-docker-hub-username>/my-tf-model:latest
docker push <your-docker-hub-username>/my-tf-model:latest
```

2. Modify the `deployment.yaml` file to use your Docker Hub username.
```yaml
spec:
  containers:
  - name: tf-model
    image: <your-docker-hub-username>/my-tf-model:latest
    ports:
    - containerPort: 8501
```

3. Make sure you have Kubernetes running. You can use Docker Desktop Kubernetes or MiniKube for local development.
4. Run `kubectl apply -f deployment.yaml` to deploy the model to Kubernetes.
5. Run `kubectl apply -f service.yaml` to expose the model to the outside world.

You can verify the deployment by running `kubectl get pods` and `kubectl get services`.

Now, you can test the model by sending a request to the Kubernetes service. In this example, we used `NodePort` to expose the service, so the service will be available at `http://localhost:<node-port>`. You can find the node port by running `kubectl get services`.

You may also use port forwarding to access the service directly by running `kubectl port-forward svc/tf-model-service 8080:8501`. This will forward the service from kubernetes port 8501 to localhost port 8080. If you get an error, you may need to double check the port in the `service.yaml` file.

Test the model as follows, and replace `<node-port>` with the actual node port (8080 if you used the port forwarding command from above):

### Unix-based systems
```bash
curl -X POST http://localhost:<node-port>/v1/models/my_model:predict -d '{"instances": [[0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]]}'
```

### Windows
```powershell
Invoke-WebRequest -Uri http://localhost:<node-port>/v1/models/my_model:predict -Method POST -Body '{"instances": [[0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]]}' -ContentType "application/json"
```