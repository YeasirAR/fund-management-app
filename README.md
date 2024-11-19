# **Fund Management App Backend**

This is the backend for the Fund Management App. It provides APIs for user authentication, email verification, fund transactions (deposit, withdraw, transfer), and profile management.

---

## **Table of Contents**

1. [Features](#features)
2. [Technologies Used](#technologies-used)
3. [Setup Instructions](#setup-instructions)
4. [Environment Variables](#environment-variables)
5. [API Documentation](#api-documentation)
   - [Authentication](#1-authentication)
   - [Transactions](#2-transactions)
   - [Profile](#3-profile)
6. [Testing APIs](#testing-apis)
7. [Contributing](#contributing)
8. [License](#license)

---

## **Features**

- User authentication with JWT.
- Email verification using Nodemailer.
- Secure password hashing with bcrypt.
- Fund transactions (deposit, withdraw, transfer).
- User profile management.
- RESTful API structure.

---

## **Technologies Used**

- **Node.js**: Backend runtime environment.
- **Express.js**: Web framework for building APIs.
- **MongoDB**: Database for storing user and transaction data.
- **Mongoose**: ODM for MongoDB.
- **Nodemailer**: For sending emails.
- **bcrypt**: For password hashing.
- **jsonwebtoken**: For generating and verifying JWT tokens.

---

## **Setup Instructions**

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/fund-management-backend.git
   cd fund-management-backend
   ```

2. **Install dependencies**:
   ```bash
   npm install
   ```

3. **Set up environment variables**:
   - Create a `.env` file in the root directory and add:
     ```plaintext
     MONGO_URI=your-mongodb-uri
     JWT_SECRET=your-jwt-secret
     EMAIL=your-email
     EMAIL_PASSWORD=your-email-password
     PORT=5000
     ```

4. **Start the server**:
   ```bash
   npm run dev
   ```

5. The server will run on `http://localhost:5000`.

---

## **Environment Variables**

| Variable        | Description                                  | Example                                |
|------------------|----------------------------------------------|----------------------------------------|
| `MONGO_URI`      | MongoDB connection string                   | `mongodb+srv://user:password@cluster.mongodb.net/dbname` |
| `JWT_SECRET`     | Secret key for JWT                          | `your-secret-key`                      |
| `EMAIL`          | Email address for sending emails            | `your-email@gmail.com`                 |
| `EMAIL_PASSWORD` | App password for the email account          | `your-app-password`                    |
| `PORT`           | Port for the server to run on               | `5000`                                 |

---

## **API Documentation**

### **Base URL**
`http://localhost:5000`

---

### **1. Authentication**

#### **1.1 Register**
- **Endpoint**: `/api/auth/register`
- **Method**: `POST`
- **Description**: Registers a new user and sends a verification email.
- **Request Body**:
  ```json
  {
    "name": "John Doe",
    "email": "john@example.com",
    "password": "password123"
  }
  ```
- **Response**:
  ```json
  {
    "message": "User registered. Please verify your email."
  }
  ```

---

#### **1.2 Verify Email**
- **Endpoint**: `/api/auth/verify-email`
- **Method**: `GET`
- **Description**: Verifies the user's email using a token.
- **Query Parameters**:
  - `token`: JWT token sent in the email.
- **Response**:
  ```json
  {
    "message": "Email verified successfully."
  }
  ```

---

#### **1.3 Login**
- **Endpoint**: `/api/auth/login`
- **Method**: `POST`
- **Description**: Logs in the user and returns a JWT token.
- **Request Body**:
  ```json
  {
    "email": "john@example.com",
    "password": "password123"
  }
  ```
- **Response**:
  ```json
  {
    "token": "jwt-token"
  }
  ```

---

### **2. Transactions**

#### **2.1 Deposit Funds**
- **Endpoint**: `/api/transactions/deposit`
- **Method**: `POST`
- **Headers**:
  - `Authorization: Bearer <jwt-token>`
- **Description**: Deposits funds to the user's account.
- **Request Body**:
  ```json
  {
    "amount": 1000
  }
  ```
- **Response**:
  ```json
  {
    "message": "Deposit successful.",
    "balance": 11000
  }
  ```

---

#### **2.2 Withdraw Funds**
- **Endpoint**: `/api/transactions/withdraw`
- **Method**: `POST`
- **Headers**:
  - `Authorization: Bearer <jwt-token>`
- **Description**: Withdraws funds from the user's account.
- **Request Body**:
  ```json
  {
    "amount": 500
  }
  ```
- **Response**:
  ```json
  {
    "message": "Withdrawal successful.",
    "balance": 10500
  }
  ```

---

#### **2.3 Transfer Funds**
- **Endpoint**: `/api/transactions/transfer`
- **Method**: `POST`
- **Headers**:
  - `Authorization: Bearer <jwt-token>`
- **Description**: Transfers funds to another user.
- **Request Body**:
  ```json
  {
    "amount": 100,
    "recipientEmail": "recipient@example.com"
  }
  ```
- **Response**:
  ```json
  {
    "message": "Transfer successful.",
    "balance": 10400
  }
  ```

---

### **3. Profile**

#### **3.1 Get User Profile**
- **Endpoint**: `/api/profile/me`
- **Method**: `GET`
- **Headers**:
  - `Authorization: Bearer <jwt-token>`
- **Description**: Retrieves the user's profile information.
- **Response**:
  ```json
  {
    "name": "John Doe",
    "email": "john@example.com",
    "balance": 10400
  }
  ```

---

