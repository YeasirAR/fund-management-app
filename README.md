
# Fund Management App

## Overview

The **Fund Management App** is a comprehensive platform for users to manage their funds efficiently. It includes features like user registration, login, email verification, and password recovery. The app is built with a **Node.js backend** and a **Flutter frontend** for a seamless user experience.

---

## Features

### Backend
- **User Authentication**: Registration, login, and email verification.
- **Fund Management**: Deposit, withdrawal, and transfers.
- **Error Handling**: Graceful error messages for API failures.
- **Email Integration**: Sends verification codes and password reset codes.

### Frontend
- Built using **Flutter** for cross-platform support (iOS and Android).
- Modern and responsive UI for seamless user experience.
- Smooth navigation between signup, verification, and reset password screens.
- Input validation and error feedback for better UX.

---

## Technologies Used

### Backend
- **Node.js** with **Express.js** for server-side logic.
- **MongoDB** for database storage.
- **JWT (JSON Web Tokens)** for authentication.
- **Nodemailer** for sending emails.

### Frontend
- **Flutter**:
  - State management using **Provider**.
  - Networking with the **HTTP** package.
  - Secure storage using **flutter_secure_storage**.

---

## API Documentation

### Authentication APIs

#### 1. **User Registration**
**Endpoint**: `/api/auth/register`  
**Method**: `POST`  
**Request Body**:
```json
{
  "name": "John Doe",
  "email": "johndoe@example.com",
  "password": "password123"
}
```
**Response**:
```json
{
  "message": "User registered. Please verify your email."
}
```

---

#### 2. **Verify Email**
**Endpoint**: `/api/auth/verify-email`  
**Method**: `POST`  
**Request Body**:
```json
{
  "email": "johndoe@example.com",
  "code": "123456"
}
```
**Response**:
```json
{
  "message": "Email verified successfully."
}
```
**Error**:
```json
{
  "error": "Invalid verification code."
}
```

---

#### 3. **Login**
**Endpoint**: `/api/auth/login`  
**Method**: `POST`  
**Request Body**:
```json
{
  "email": "johndoe@example.com",
  "password": "password123"
}
```
**Response**:
```json
{
  "token": "your-jwt-token"
}
```
**Error**:
```json
{
  "error": "Invalid credentials."
}
```

---

#### 4. **Forgot Password**
**Endpoint**: `/api/auth/forgot-password`  
**Method**: `POST`  
**Request Body**:
```json
{
  "email": "johndoe@example.com"
}
```
**Response**:
```json
{
  "message": "Reset code sent to email."
}
```
**Error**:
```json
{
  "error": "User not found."
}
```

---

#### 5. **Reset Password**
**Endpoint**: `/api/auth/reset-password`  
**Method**: `POST`  
**Request Body**:
```json
{
  "email": "johndoe@example.com",
  "code": "123456",
  "newPassword": "newpassword123"
}
```
**Response**:
```json
{
  "message": "Password reset successfully."
}
```
**Error**:
```json
{
  "error": "Invalid reset code."
}
```

---

### Fund Management APIs

#### 6. **Get Fund Summary**
**Endpoint**: `/api/funds/summary`  
**Method**: `GET`  
**Headers**:  
`Authorization: Bearer <your-jwt-token>`  

**Response**:
```json
{
  "currentBalance": 1000,
  "availableBalance": 900
}
```

---

#### 7. **Deposit Funds**
**Endpoint**: `/api/funds/deposit`  
**Method**: `POST`  
**Headers**:  
`Authorization: Bearer <your-jwt-token>`  
**Request Body**:
```json
{
  "amount": 500
}
```
**Response**:
```json
{
  "message": "Funds deposited successfully."
}
```

---

#### 8. **Withdraw Funds**
**Endpoint**: `/api/funds/withdraw`  
**Method**: `POST`  
**Headers**:  
`Authorization: Bearer <your-jwt-token>`  
**Request Body**:
```json
{
  "amount": 300
}
```
**Response**:
```json
{
  "message": "Funds withdrawn successfully."
}
```

---

#### 9. **Transfer Funds**
**Endpoint**: `/api/funds/transfer`  
**Method**: `POST`  
**Headers**:  
`Authorization: Bearer <your-jwt-token>`  
**Request Body**:
```json
{
  "toAccount": "recipient@example.com",
  "amount": 200
}
```
**Response**:
```json
{
  "message": "Funds transferred successfully."
}
```

---

## Installation

### Backend
1. Navigate to the `fund-management-backend` folder:
   ```bash
   cd fund-management-backend
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Start the server:
   ```bash
   npm start
   ```

### Frontend
1. Navigate to the `fund-management-frontend` folder:
   ```bash
   cd fund-management-frontend
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

---


