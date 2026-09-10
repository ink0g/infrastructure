# 🌐 Infrastructure as Code: Go Application & Monitoring Deployment

Проект демонстрирует практическое применение методологии IaC и практик CI/CD для развертывания веб-приложения на языке Go с автоматическим подключением мониторинга (Prometheus + Grafana).

## 🏗️ Архитектура и компоненты

Проект разворачивает две изолированные виртуальные машины:
1. **Server 1 (App Node):** Хостинг для веб приложения на Golang, упакованного в Docker.
2. **Server 2 (Monitoring Node):** Сервер мониторинга.

## 🛠️ Стек технологий
Terraform, Ansible, Docker, Go, Prometheus, Grafana

## 📂 Структура репозитория

```text
├── terraform/          # Скрипты инициализации инфраструктуры
│   ├── main.tf         # Описание провайдера и ресурсов VM
│   ├── cloud_init.cfg  # Первичная настройка пользователей и SSH
│   └── network_config.cfg
├── ansible/            # Конфигурация ОС и развертывание сервисов
│   ├── ansible.cfg     # Глобальные настройки Ansible
│   ├── hosts.ini       # Инвентарь (IP-адреса управляемых серверов)
│   ├── playbook.yml    # Главный сценарий развертывания
│   └── prometheus.yml.j2 # Шаблон конфигурацции Prometheus
└── app/                # Исходный код приложения
    ├── Dockerfile      # сборка Go-приложения
    ├── main.go         # HTTP-сервер на Go
    ├── go.mod
    └── go.sum
```

## 🚀 Быстрый запуск

### 1. Подготовка окружения
Перед стартом убедитесь, что у вас установлены `terraform`, `ansible` и утилиты для развертывания виртуальных машин локально.

### 2. Развертывание инфраструктуры (Terraform)
Перейдите в директорию Terraform, инициализируйте провайдер и примените конфигурацию:
```bash
cd terraform/
terraform init
terraform apply -auto-approve
```
*После успешного выполнения Terraform выведет IP-адреса созданных серверов. Может быть надо будет еще раз ввести terraform apply если не выдало ip*

### 3. Конфигурация и Деплой (Ansible)
1. Перенесите полученные IP-адреса в файл `ansible/hosts.ini`.
2. Запустите плейбук
```bash
cd ../ansible/
ansible-playbook -i hosts.ini playbook.yml
```

## 📊 Проверка работы
* **Приложение:** доступно по адресу `http://<APP_SERVER_IP>:8080`
* **Метрики Prometheus:** `http://<MONITORING_SERVER_IP>:9090`
* **Панели Grafana:** `http://<MONITORING_SERVER_IP>:3000` (дефолтный логин/пароль: `admin/admin`)

---
*Проект разработан в учебных целях для демонстрации навыков автоматизации инфраструктуры.*
