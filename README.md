# Task-2: Deploy Hello World App on Kubernetes (EKS)

A beginner-friendly project to deploy a simple Node.js application on AWS EKS using Docker and Kubernetes.

---

## 📁 What's in this project?

- **server.js** - Simple Node.js web server that shows "Hello World! Deployed on EKS"
- **Dockerfile** - Instructions to build a Docker container (multi-stage build)
- **package.json** - Basic app information for Node.js
- **deployment.yaml** - Kubernetes deployment file (runs 2 copies of our app)
- **service.yaml** - Kubernetes service file (exposes our app to internet)
- **ingress.yaml** - Ingress configuration (not used currently)

---

## 🚀 What We Did (Step by Step)

### Step 1: Created the Application
- Made a simple Node.js app that shows "Hello World!"
- Created a `package.json` file for the app

### Step 2: Containerized the App
- Wrote a **multi-stage Dockerfile**
  - Stage 1: Prepares the base and dependencies
  - Stage 2: Creates the final production image
- Built Docker image: `docker build -t hello-world-app .`

### Step 3: Pushed to AWS ECR (Container Registry)
- Tagged the image for ECR
- Logged in to AWS ECR
- Pushed image to: `539247494152.dkr.ecr.ap-south-1.amazonaws.com/node-image-1:v2`

### Step 4: Deployed to Kubernetes (EKS)
- Created **deployment.yaml** - tells Kubernetes to run 2 copies (replicas) of our app
- Created **service.yaml** - creates a Load Balancer to access the app from internet
- Applied files: `kubectl apply -f deployment.yaml` and `kubectl apply -f service.yaml`

### Step 5: Updated the App
- Changed content in `server.js`
- Built new image (v2)
- Pushed to ECR
- Updated deployment: `kubectl set image deployment/hello-world-app hello-world=...`

---

## 😓 Problems I Faced (And How We Fixed Them)

### Problem 1: Tried to use HTTPS with ACM Certificate
**What happened:**
- Wanted to use our domain name with HTTPS
- Added ACM certificate to the service
- Got error: `CertificateNotFound`

**Why it failed:**
- Kubernetes LoadBalancer service creates a **Classic Load Balancer (CLB)**
- Classic Load Balancer does NOT support ACM certificates ❌
- ACM certificates only work with **Application Load Balancer (ALB)**

**Solution:**
- Removed HTTPS and ACM certificate
- Used simple HTTP LoadBalancer instead ✅

---

### Problem 2: AWS Load Balancer Controller Installation Failed
**What happened:**
- Tried to install AWS Load Balancer Controller (needed for ALB + Ingress)
- Many errors came up:
  - Helm was not installed
  - OIDC provider was missing
  - TLS certificate secret missing
  - Controller pod kept crashing
  - VPC configuration issues

**Why it failed:**
- Too complex for beginners
- Many dependencies needed
- Multiple configuration steps required

**Solution:**
- Gave up on Ingress + ALB approach
- Used simple LoadBalancer service instead (much easier!) ✅

---

### Problem 3: Application Not Loading from Load Balancer
**What happened:**
- Load balancer was created but app was not accessible
- Got "Connection Refused" error

**Why it failed:**
- Security group on Load Balancer was blocking port 80
- Health check was failing

**Solution:**
- Added port 80 rule to security group
- Recreated the LoadBalancer service
- Everything worked! ✅

---

## 🎯 Final Working Setup

**What we have now:**
- ✅ Simple Node.js Hello World app
- ✅ Docker containerized with multi-stage build
- ✅ Image stored in AWS ECR
- ✅ Running on AWS EKS cluster with 2 replicas
- ✅ Accessible via HTTP Load Balancer

**Live URL:** http://a846e6f5ac9ec46c98ebdf614b937333-1872341124.ap-south-1.elb.amazonaws.com

---

## 📝 Commands We Used

### Docker Commands
```bash
# Build image
docker build -t hello-world-app:v2 .

# Tag for ECR
docker tag hello-world-app:v2 539247494152.dkr.ecr.ap-south-1.amazonaws.com/node-image-1:v2

# Login to ECR
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 539247494152.dkr.ecr.ap-south-1.amazonaws.com

# Push to ECR
docker push 539247494152.dkr.ecr.ap-south-1.amazonaws.com/node-image-1:v2
```

### Kubernetes Commands
```bash
# Apply deployment
kubectl apply -f deployment.yaml

# Apply service
kubectl apply -f service.yaml

# Check pods
kubectl get pods

# Check service
kubectl get service hello-world-service

# Update deployment with new image
kubectl set image deployment/hello-world-app hello-world=539247494152.dkr.ecr.ap-south-1.amazonaws.com/node-image-1:v2

# Check rollout status
kubectl rollout status deployment/hello-world-app
```

---

## 💡 What We Learned

1. **Multi-stage Docker builds** make images smaller and cleaner
2. **Classic Load Balancer** doesn't support ACM certificates (only ALB does)
3. **Ingress + ALB** is powerful but complex for beginners
4. **Simple LoadBalancer service** is easier and good for learning
5. **Security groups** need correct port rules for Load Balancer to work
6. **Kubernetes deployments** make it easy to update apps without downtime

---

## 🎓 For Beginners: Key Concepts

- **Docker**: Packages your app with everything it needs to run
- **ECR**: Amazon's storage for Docker images
- **Kubernetes**: Manages and runs your containers
- **EKS**: Amazon's managed Kubernetes service
- **Deployment**: Tells Kubernetes how many copies of your app to run
- **Service**: Exposes your app to the internet
- **Load Balancer**: Distributes traffic to your app copies

---

## ✅ Success!

We successfully deployed a containerized Node.js application on AWS EKS cluster using Kubernetes! 🎉

