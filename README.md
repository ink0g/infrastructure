### 🌐 Infrastructure as Code: Go App & Monitoring Deployment

Проект создавался для обучения и проверки своих знаний. Базовая работа создания, автоматизации и мониторинга серверов. Все развертывается локально. 

---

### 🏗️ Архитектура проекта

- **Server 1 (App):** Запускается и настраивается GO
- **Server 2 (Monitoring):** Сбор метрик и отрисовка их. Prometheus + Grafana.

---

### 🛠️ Стек технологий

- **Infrastructure:** Terraform
- **Configuration Management:** Ansible
- **Application:** Go (Golang)
- **Monitoring:** Prometheus + Grafana

---

### 🚀 Быстрый запуск

1. Развертывание инфраструктуры (Terraform)

```bash
cd terraform/
terraform init
terraform apply -auto-approve
```

_После успешного выполнения Terraform сгенерирует IP-адреса серверов._

2. Конфигурация серверов (Ansible)

Шаг 1: Скопируйте полученные IP-адреса в файл `ansible/hosts.ini`.  
Шаг 2: Запустите плейбук:

```bash
cd ../ansible/
ansible-playbook -i inventory.ini site.yml
```

---

### 📂 Структура репозитория

```text
├── terraform/         
│   ├── .terraform.lock.hcl
│   ├── cloud_init.cfg
│   ├── main.tf
│   └── network_config.cfg    
├── ansible/            # Скрипты автоматизации и настройки
│   ├── hosts.ini       # имена и IP адреса серверов
│   ├── playbook.yml    # Основной файл ансибла
│	├── ansible.cfg     # Конфиг ансибла
│   └── prometheus.yml.j2 # Конфиг для prometheus
├── app/
│   ├── Dockerfile
│   ├── go.mod
│   ├── go.sum
│   └── main.go
└── README.md
```
