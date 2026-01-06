# Talentix Platform

A production-ready talent management platform built with Spring Boot, MySQL, Docker, and automated CI/CD deployment.

## 🚀 Features

- **Complete CRUD Operations** for Employees and Departments
- **RESTful API** with comprehensive endpoints
- **MySQL 8.0** database with Flyway migrations
- **Docker containerization** with multi-stage builds
- **Multiple environments** (dev/prod) with profile-based configuration
- **Automated CI/CD** with GitHub Actions
- **Health checks** and monitoring endpoints
- **Production-ready** with security best practices

## 📋 Prerequisites

- Java 11 or higher
- Maven 3.6+
- Docker & Docker Compose
- Git

## 🛠️ Technology Stack

- **Framework**: Spring Boot 2.7.18
- **Database**: MySQL 8.0
- **Build Tool**: Maven
- **Containerization**: Docker
- **Migration**: Flyway
- **CI/CD**: GitHub Actions

## 🏗️ Project Structure

```
talentix-platform/
├── src/
│   ├── main/
│   │   ├── java/com/talentix/platform/
│   │   │   ├── TalentixPlatformApplication.java
│   │   │   ├── model/
│   │   │   │   ├── Employee.java
│   │   │   │   └── Department.java
│   │   │   ├── repository/
│   │   │   │   ├── EmployeeRepository.java
│   │   │   │   └── DepartmentRepository.java
│   │   │   ├── service/
│   │   │   │   ├── EmployeeService.java
│   │   │   │   ├── DepartmentService.java
│   │   │   │   └── impl/
│   │   │   │       ├── EmployeeServiceImpl.java
│   │   │   │       └── DepartmentServiceImpl.java
│   │   │   ├── controller/
│   │   │   │   ├── EmployeeController.java
│   │   │   │   └── DepartmentController.java
│   │   │   └── exception/
│   │   │       └── GlobalExceptionHandler.java
│   │   └── resources/
│   │       ├── application.yml
│   │       ├── application-dev.yml
│   │       ├── application-prod.yml
│   │       └── db/migration/
│   │           └── V1__create_tables.sql
├── scripts/
│   ├── deploy.sh
│   └── healthcheck.sh
├── .github/workflows/
│   ├── deploy-dev.yml
│   └── deploy-prod.yml
├── Dockerfile
├── docker-compose.yml
├── docker-compose.prod.yml
├── .dockerignore
├── .gitignore
├── .env.example
├── pom.xml
└── README.md
```

## 🚦 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/talentix-platform.git
cd talentix-platform
```

### 2. Environment Setup

Create a `.env` file from the example:

```bash
cp .env.example .env
```

Edit `.env` with your configuration:

```env
MYSQL_ROOT_PASSWORD=your_secure_password
MYSQL_DATABASE=talentix_dev
GITHUB_USERNAME=your_github_username
```

### 3. Run with Docker Compose (Development)

```bash
docker-compose up -d
```

This will start:
- MySQL on port 3307
- Spring Boot application on port 8081

### 4. Verify Deployment

```bash
# Check health
curl http://localhost:8081/actuator/health

# Get all employees
curl http://localhost:8081/api/employees

# Get all departments
curl http://localhost:8081/api/departments
```

## 📡 API Endpoints

### Employee Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/employees` | Get all employees |
| GET | `/api/employees/{id}` | Get employee by ID |
| POST | `/api/employees` | Create new employee |
| PUT | `/api/employees/{id}` | Update employee |
| DELETE | `/api/employees/{id}` | Delete employee |
| GET | `/api/employees/department/{departmentId}` | Get employees by department |
| GET | `/api/employees/job-title/{jobTitle}` | Get employees by job title |

### Department Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/departments` | Get all departments |
| GET | `/api/departments/{id}` | Get department by ID |
| POST | `/api/departments` | Create new department |
| PUT | `/api/departments/{id}` | Update department |
| DELETE | `/api/departments/{id}` | Delete department |

### Example Requests

#### Create Employee

```bash
curl -X POST http://localhost:8081/api/employees \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "John",
    "lastName": "Doe",
    "email": "john.doe@example.com",
    "phoneNumber": "+1-555-0123",
    "jobTitle": "Software Engineer",
    "salary": 95000.00,
    "departmentId": 1
  }'
```

#### Create Department

```bash
curl -X POST http://localhost:8081/api/departments \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Engineering",
    "description": "Software development team",
    "managerId": 1
  }'
```

## 🔧 Development

### Build and Run Locally

```bash
# Build
mvn clean package

# Run with dev profile
java -jar target/talentix-platform.jar --spring.profiles.active=dev
```

### Run Tests

```bash
mvn test
```

## 🐳 Docker Commands

### Development Environment

```bash
# Start services
docker-compose up -d

# View logs
docker-compose logs -f app

# Stop services
docker-compose down

# Rebuild and start
docker-compose up -d --build
```

### Production Environment

```bash
# Deploy production
./scripts/deploy.sh prod

# Check health
./scripts/healthcheck.sh http://localhost:8080/actuator/health
```

## 🚀 CI/CD Pipeline

### Development Deployment

Automatic deployment on push to `develop` branch:

```bash
git checkout develop
git add .
git commit -m "Your changes"
git push origin develop
```

### Production Deployment

Manual deployment via GitHub Actions or release:

1. **Manual Workflow**:
    - Go to Actions → Deploy to Production
    - Click "Run workflow"
    - Enter version tag

2. **Release-based**:
   ```bash
   git tag -a v1.0.0 -m "Release version 1.0.0"
   git push origin v1.0.0
   ```

### Required GitHub Secrets

Configure these secrets in your GitHub repository:

**Development:**
- `DEV_SERVER_HOST`
- `DEV_SERVER_USER`
- `DEV_SERVER_SSH_KEY`
- `DEV_MYSQL_ROOT_PASSWORD`

**Production:**
- `PROD_SERVER_HOST`
- `PROD_SERVER_USER`
- `PROD_SERVER_SSH_KEY`
- `PROD_MYSQL_ROOT_PASSWORD`
- `PROD_MYSQL_PASSWORD`

## 🔐 Security Considerations

- Non-root user in Docker containers
- Environment-based configuration
- No hardcoded credentials
- SSL enabled in production
- Connection pooling configured
- Health check endpoints secured

## 📊 Monitoring

### Health Endpoint

```bash
curl http://localhost:8081/actuator/health
```

Response:
```json
{
  "status": "UP",
  "components": {
    "db": {
      "status": "UP"
    },
    "diskSpace": {
      "status": "UP"
    }
  }
}
```

### Application Metrics

```bash
curl http://localhost:8081/actuator/metrics
```

## 🐛 Troubleshooting

### Database Connection Issues

```bash
# Check MySQL container
docker logs talentix-mysql-dev

# Test connection
docker exec -it talentix-mysql-dev mysql -u root -p
```

### Application Not Starting

```bash
# Check application logs
docker logs talentix-app-dev

# Check health
./scripts/healthcheck.sh http://localhost:8081/actuator/health
```

### Port Already in Use

```bash
# Find process using port 8081
lsof -i :8081

# Kill process
kill -9 <PID>
```

## 📝 Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `SPRING_PROFILES_ACTIVE` | Active profile (dev/prod) | dev |
| `MYSQL_HOST` | MySQL host | mysql |
| `MYSQL_DATABASE` | Database name | talentix_dev |
| `MYSQL_USER` | Database user | root |
| `MYSQL_PASSWORD` | Database password | root |
| `SERVER_PORT` | Application port | 8081 (dev), 8080 (prod) |

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License.

## 📧 Support

For issues and questions:
- Create an issue on GitHub
- Email: support@talentix.com

## 🙏 Acknowledgments

- Spring Boot Team
- Docker Community
- MySQL Development Team