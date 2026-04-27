# PayFlow — Banking Payment System

## About

PayFlow is a web-based banking payment system that simulates core operations of a real bank: account management, credit cards, payments, transfers, and role-based administration. It is an **educational project** built for the 2026 coursework, demonstrating a full-stack Spring Boot application with three distinct user roles (Client, Manager, Admin) and a server-rendered FreeMarker UI.

## Tech Stack

- **Java** 17
- **Spring Boot** 4.0.2 (Web, Data JPA, Security, Validation, DevTools)
- **Spring Security** (BCrypt password hashing, role-based access)
- **Hibernate / Jakarta Persistence API** 3.2.0
- **MySQL** 8.x (via `mysql-connector-j`)
- **FreeMarker** (`spring-boot-starter-freemarker` + `freemarker-java8` 2.1.0) for server-side templates
- **Lombok** 1.18.42
- **Maven** (build, with `spring-boot-maven-plugin`)
- **JUnit 5** + Spring Boot Test (testing)
- **SLF4J / Logback** (rolling file appenders configured in `logback-spring.xml`)

## Features

### CLIENT (`/dashboard/**`)
- Register and log in
- Personal dashboard with account/card/transaction overview
- Open new bank accounts and view account details
- Add/delete credit cards, change PIN, set spending limits, block/unblock cards
- Make payments, replenish accounts, and execute account-to-account transfers
- View transaction history with paging and cancel pending payments
- Manage profile and change password

### MANAGER (`/manager/**`)
- Separate manager login portal
- Manager dashboard with operational stats
- View all transactions across the system
- View reports

### ADMIN (`/admin/**`)
- Separate admin login portal
- Admin dashboard with system-wide statistics
- User management: list users, assign roles, block/unblock, delete
- Transaction management: approve, reject, cancel, refund
- Reports and system settings
- Update own admin profile and password

### Cross-cutting
- BCrypt password storage; automatic re-hash of any plain-text legacy passwords on startup
- Login attempt throttling (`LoginAttemptService`)
- Global exception handling (`GlobalExceptionHandler`)
- Audit logging to `logs/payflow.log` and `logs/security.log` (rotated, gzipped)

## Prerequisites

- Java 17+
- Maven 3.8+
- MySQL 8.x

## Setup & Run

### 1. Clone the repository
```bash
git clone https://github.com/zivak0707-lang/Course-2026-np.git
cd Course-2026-np
```

### 2. Create MySQL database
```sql
CREATE DATABASE `course-2026-np` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### 3. Configure `application.properties`
Open `src/main/resources/application.properties` and set your MySQL password:
```properties
spring.datasource.username=root
spring.datasource.password=YOUR_MYSQL_PASSWORD
spring.datasource.url=jdbc:mysql://localhost:3306/course-2026-np
```
The schema is generated automatically (`spring.jpa.hibernate.ddl-auto=update`).

### 4. Run
```bash
mvn spring-boot:run
```
On Windows you can also use the wrapper: `mvnw.cmd spring-boot:run`.

### 5. Open in browser
http://localhost:8080

## Default Test Accounts

| Role    | Email                | Password    |
|---------|----------------------|-------------|
| Admin   | admin@payflow.com    | admin123    |
| Manager | manager@payflow.com  | manager123  |
| Client  | client@payflow.com   | client123   |

These users are created automatically by `DataInitializer` on first run. Passwords are stored as BCrypt hashes.

## Project Structure

```
src/main/java/ua/com/kisit/course2026np/
├── Main.java                  # Spring Boot entry point
├── config/                    # DataInitializer, WebConfig
├── controller/                # HomeController, ClientController, ManagerController,
│                              # AdminController, AccountController, CreditCardController,
│                              # PaymentController, DashboardAccountController, TestController
├── dto/                       # ChangePinRequest, DashboardStats, SpendingLimitRequest,
│                              # TransactionPage
├── entity/                    # User, Account, CreditCard, Payment + enums
│                              # (UserRole, AccountStatus, PaymentStatus, PaymentType)
├── exception/                 # GlobalExceptionHandler
├── repository/                # Spring Data JPA repositories
├── security/                  # SecurityConfig (Spring Security setup)
├── service/                   # AccountService, AdminService, CreditCardService,
│                              # DashboardService, LoginAttemptService, ManagerService,
│                              # PaymentService, UserService
└── validation/                # Custom validators

src/main/resources/
├── application.properties     # DB and FreeMarker config
├── logback-spring.xml         # Rolling file appenders for payflow & security logs
├── static/                    # css, js, favicon
└── templates/                 # FreeMarker (.ftl) views — admin, manager, client
```

## Running Tests

```bash
mvn test
```

The project ships with **7 test classes** (~97 test methods) covering:
- Entity tests: `UserTest`, `AccountTest`, `CreditCardTest`, `PaymentTest`
- Service tests: `PaymentServiceTest`, `TransferDebugTest`
- Spring context smoke test: `Course2026NpApplicationTests`

## License

Educational project — Зівак Сергій, 2026
