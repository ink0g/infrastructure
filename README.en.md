# 🌐 Infrastructure as Code: Go Application & Monitoring Deployment

The project demonstrates the practical application of the IaC methodology and CI/CD practices for deploying a web application written in Go with automatic monitoring setup (Prometheus + Grafana).

## 🏗️ Architecture and Components

The project deploys two isolated virtual machines:
1. **Server 1 (App Node):** Hosting for the Golang web application packaged in Docker.
2. **Server 2 (Monitoring Node):** Monitoring server.

## 🛠️ Technology Stack
Terraform, Ansible, Docker, Go, Prometheus, Grafana

## 📂 Repository Structure

```text
├── terraform/          # Infrastructure initialization scripts
│   ├── main.tf         # Provider and VM resource description
│   ├── cloud_init.cfg  # Initial user and SSH setup
│   └── network_config.cfg
├── ansible/            # OS configuration and service deployment
│   ├── ansible.cfg     # Global Ansible settings
│   ├── hosts.ini       # Inventory (IP addresses of managed servers)
│   ├── playbook.yml    # Main deployment playbook
│   └── prometheus.yml.j2 # Prometheus configuration template
└── app/                # Application source code
    ├── Dockerfile      # Builds the Go application
    ├── main.go         # HTTP server in Go
    ├── go.mod
    └── go.sum
```

## 🚀 Quick Start

### 1. Environment Preparation
Before starting, make sure you have `terraform`, `ansible`, and utilities for deploying virtual machines locally installed.

### 2. Infrastructure Deployment (Terraform)
Navigate to the Terraform directory, initialize the provider, and apply the configuration:
```bash
cd terraform/
terraform init
terraform apply -auto-approve
```
*After successful Terraform execution, it will output the IP addresses of the created servers. You may need to run terraform apply again if it did not output the IPs*

### 3. Configuration and Deployment (Ansible)
1. Transfer the obtained IP addresses to the `ansible/hosts.ini` file.
2. Run the playbook
```bash
cd ../ansible/
ansible-playbook -i hosts.ini playbook.yml
```

## 📊 Verification
* **Application:** available at `http://<APP_SERVER_IP>:8080`
* **Prometheus metrics:** `http://<MONITORING_SERVER_IP>:9090`
* **Grafana dashboards:** `http://<MONITORING_SERVER_IP>:3000` (default login/password: `admin/admin`)

---
*The project was developed for educational purposes to demonstrate infrastructure automation skills.*
