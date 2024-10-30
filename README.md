Here’s a **README.md** for your GitHub repository. This README provides clear instructions for deploying the **Python Flask + MySQL app** on OpenShift with **Service Mesh** integration, Helm-based deployment, and secrets managed via **Azure Key Vault** or **HashiCorp Vault**.

---

# **Python Flask + MySQL App on OpenShift with Service Mesh**

This repository contains a **Python Flask** web application integrated with a **MySQL database**, deployed on **OpenShift** using **Helm charts**. The project leverages **OpenShift Service Mesh** (based on Istio) for traffic management, observability, and security. Additionally, secrets are securely managed using **Azure Key Vault** or **HashiCorp Vault**.

---

## **Features**

- **Python Flask Web App**: Simple app connecting to MySQL and displaying the current time from the database.
- **Helm-based Deployment**: Manages Kubernetes resources for the app and database.
- **OpenShift Service Mesh Integration**: Enables mTLS, traffic routing, and observability with Istio.
- **Secrets Management with Vault**: Securely inject secrets (e.g., MySQL credentials) using Azure Key Vault or HashiCorp Vault.
- **CI/CD with GitHub Actions**: Automates the build and deployment process.

---

## **Architecture**

1. **Flask App** connects to a MySQL database to fetch data.
2. **MySQL** is deployed with a **Persistent Volume Claim (PVC)** for data persistence.
3. **Service Mesh** manages traffic between services with **VirtualService** routing and **mTLS**.
4. **Vault** stores and injects secrets such as database credentials.
5. **Kiali** and **Jaeger** provide observability for service-to-service communication.

---

## **Repository Structure**

```
python-mysql-app/
│
├── app.py                   # Flask application code
├── requirements.txt         # Dependencies
├── Dockerfile               # Dockerfile for container build
├── charts/                  # Helm chart for deployment
│       ├── Chart.yaml       # Helm chart metadata
│       ├── values.yaml      # Configuration values
│       ├── templates/       # Kubernetes templates
│           ├── deployment.yaml
│           ├── service.yaml
│           ├── pvc.yaml
│           ├── mysql-deployment.yaml
│           ├── secret.yaml
│           └── virtualservice.yaml
└── .github/
    └── workflows/
        └── deploy.yaml      # GitHub Actions workflow for CI/CD
```

---

## **Prerequisites**

- **OpenShift Cluster** with Service Mesh enabled.
- **Helm CLI** installed.
- **Vault** (Azure Key Vault or HashiCorp Vault) configured for secrets management.
- **GitHub Repository Secrets** configured:
  - `OPENSHIFT_TOKEN`: OpenShift API token.
  - `OPENSHIFT_SERVER`: OpenShift cluster URL.

---

## **Deployment Instructions**

### **Step 1: Setup OpenShift Service Mesh**

1. Add your namespace to the **ServiceMeshMemberRoll**:
   ```bash
   oc apply -f - <<EOF
   apiVersion: maistra.io/v1
   kind: ServiceMeshMemberRoll
   metadata:
     name: default
     namespace: istio-system
   spec:
     members:
       - <your-namespace>
   EOF
   ```

2. Enable **mTLS**:
   ```bash
   oc apply -f - <<EOF
   apiVersion: security.istio.io/v1beta1
   kind: PeerAuthentication
   metadata:
     name: default
     namespace: <your-namespace>
   spec:
     mtls:
       mode: STRICT
   EOF
   ```

---

### **Step 2: Deploy the App Using Helm**

1. Clone the repository:
   ```bash
   git clone https://github.com/<your-username>/python-mysql-app.git
   cd python-mysql-app
   ```

2. Install the Helm chart:
   ```bash
   helm upgrade --install python-mysql-app charts/python-mysql-app \
     --set image.repository=<your-registry>/python-mysql-app
   ```

---

### **Step 3: Set Up GitHub Actions for CI/CD**

1. Push your changes to GitHub:
   ```bash
   git add .
   git commit -m "Initial commit with Service Mesh support"
   git push origin main
   ```

2. Verify the **GitHub Actions workflow**:
   - Go to **Actions** in your GitHub repository to confirm the deployment process.

---

### **Step 4: Verify Deployment**

1. Check the **VirtualService route**:
   ```bash
   oc get virtualservice python-mysql-route -o yaml
   ```

2. Access the **Kiali Dashboard**:
   ```bash
   oc get routes -n istio-system kiali
   ```

3. Trace service requests in **Jaeger**:
   ```bash
   oc get routes -n istio-system jaeger
   ```

---

### **Step 5: Access the Application**

Retrieve the route for the Flask app:

```bash
oc get routes -n <your-namespace>
```

Access the app at:

```
http://<your-app-route>/
```

---

## **Monitoring and Observability**

- **Kiali**: Visualizes service-to-service communication.
- **Jaeger**: Provides distributed tracing for requests.
- **Prometheus**: Monitors app metrics and sets alerts.

---

## **Secrets Management**

### **Using Azure Key Vault**

1. Store MySQL credentials in **Azure Key Vault**.
2. Use the **Azure CSI driver** to inject secrets as Kubernetes secrets.

### **Using HashiCorp Vault**

1. Configure **Kubernetes Auth Method** in Vault.
2. Use the **Vault Agent Injector** to inject secrets into the pod.

---

## **Conclusion**

This project demonstrates how to:
- Build and deploy a **Python Flask + MySQL** application on **OpenShift** using **Helm**.
- Leverage **OpenShift Service Mesh** for secure communication and traffic control.
- Use **Vault** to manage secrets securely.
- Automate deployment with **GitHub Actions**.

With this setup, your application benefits from enhanced security, observability, and a scalable deployment strategy.

---
