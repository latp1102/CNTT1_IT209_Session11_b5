# ĐỀ THI CUỐI MÔN DEVOPS - BẢNG KIỂM & MINH CHỨNG

## Câu 1 - Linux VPS, User, Permission & Environment Audit

### File minh chứng: `system_audit.sh`
Script bash kiểm tra:
- User `devops_exam` tồn tại
- User thuộc group `docker`
- File `/home/devops_exam/app/setup.sh` có permission `700`
- Ghi kết quả kiểm tra dung lượng `/`, RAM, Java JDK 17, Docker Engine vào `/home/devops_exam/system_audit.log`

### Các bước thực hiện trên VPS Ubuntu 22.04
```bash
sudo useradd -m -s /bin/bash devops_exam
sudo usermod -aG docker devops_exam
sudo mkdir -p /home/devops_exam/app
sudo touch /home/devops_exam/app/setup.sh
sudo chmod 700 /home/devops_exam/app/setup.sh
sudo bash system_audit.sh
cat /home/devops_exam/system_audit.log
```

---

## Câu 2 - Git Branching, Merge Conflict & Spring Boot REST API

### Git flow minh chứng
```bash
git init
git add .
git commit -m "Initial commit"

# Tạo branch feature/product-service
git checkout -b feature/product-service
# Chỉnh sửa application.yaml: server.port: 8080
git add .
git commit -m "feat: configure application port to 8080"

# Quay về main, đổi server.port: 9090
git checkout main
# Chỉnh sửa application.yaml: server.port: 9090
git add .
git commit -m "chore: set server.port to 9090"

# Merge và giải quyết conflict, giữ server.port: 8080
git merge feature/product-service
# Xử lý conflict trong application.yaml, giữ lại giá trị 8080
git add .
git commit -m "Merge branch 'feature/product-service'"
```

### API đã xây dựng
- GET /api/products
- POST /api/products
- PUT /api/products/{id}
- DELETE /api/products/{id}
- GET /actuator/health

---

## Câu 3 - Multi-stage Dockerfile & Docker Compose

### File minh chứng
- `Dockerfile`
- `.dockerignore`
- `docker-compose.yml`
- `.env`

### Build
```bash
docker build -t springboot-mysql-api:v1 .
```

### Run
```bash
docker compose up -d
docker compose ps
curl -i http://localhost:8080/actuator/health
```

---

## Câu 4 - CI/CD GitHub Actions, Trivy & Deployment VPS

### File minh chứng
- `.github/workflows/ci-cd.yml`

### Cấu hình Secrets trên GitHub
- `DOCKERHUB_USERNAME`
- `DOCKERHUB_TOKEN`
- `VPS_HOST`
- `VPS_USERNAME`
- `VPS_SSH_KEY`

### Pipeline gồm
- Job `ci-test`: setup JDK 17, cache Gradle, MySQL service, chạy `./gradlew check test`
- Build Docker image, quét Trivy (fail nếu CRITICAL)
- Push Docker Hub với tags `${{ github.sha }}` và `latest`
- Job `cd-deploy`: deploy qua SSH, health check `/actuator/health` tối đa 60s, rollback nếu fail
