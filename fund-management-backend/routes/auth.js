const express = require('express');
const jwt = require('jsonwebtoken');
const argon2 = require('argon2');
const User = require('../models/User');
const sendEmail = require('../utils/sendEmail');
const nodemailer = require('nodemailer');

const router = express.Router();

// Register User
router.post('/register', async (req, res) => {
    const { name, email, password } = req.body;

    try {
        const existingUser = await User.findOne({ email });
        if (existingUser) {
            return res.status(400).json({ error: 'Email is already registered' });
        }

        const verificationCode = Math.floor(100000 + Math.random() * 900000); // 6-digit code
        const hashedPassword = await argon2.hash(password);

        const user = new User({
            name,
            email,
            password: hashedPassword,
            verificationCode,
        });

        await user.save();

        await sendEmail(
            email,
            'Verify Your Email',
            `Your email verification code is: ${verificationCode}`
        );

        res.status(201).json({ message: 'User registered. Please verify your email.' });
    } catch (err) {
        console.error('Registration Error:', err);
        res.status(500).json({ error: 'Registration failed' });
    }
});

// Verify Email
router.post('/verify-email', async (req, res) => {
    const { email, code } = req.body;

    try {
        const user = await User.findOne({ email });

        if (!user) {
            console.error(`User not found for email: ${email}`);
            return res.status(404).json({ error: 'User not found' });
        }

        console.log(`Stored code: ${user.verificationCode}`);
        console.log(`Received code: ${code}`);

        if (!user.verificationCode || user.verificationCode.toString() !== code.toString()) {
            console.error(
                `Verification failed for email: ${email}. Stored code: ${user.verificationCode}, Provided code: ${code}`
            );
            return res.status(400).json({ error: 'Invalid verification code' });
        }

        user.isVerified = true;
        user.verificationCode = null;
        await user.save();

        console.log(`Email verified successfully for user: ${email}`);
        res.json({ message: 'Email verified successfully' });
    } catch (error) {
        console.error('Verification error:', error);
        res.status(500).json({ error: 'Verification failed' });
    }
});

// Forgot Password
router.post('/forgot-password', async (req, res) => {
    const { email } = req.body;

    try {
        const user = await User.findOne({ email });
        if (!user) {
            return res.status(404).json({ error: 'User not found' });
        }

        const resetCode = Math.floor(100000 + Math.random() * 900000).toString();
        user.resetCode = resetCode;
        user.resetCodeExpiry = Date.now() + 15 * 60 * 1000; // 15 minutes
        await user.save();

        console.log(`Reset code saved for user ${email}: ${resetCode}`);

        const transporter = nodemailer.createTransport({
            service: 'gmail',
            auth: {
                user: process.env.EMAIL,
                pass: process.env.EMAIL_PASSWORD,
            },
        });

        const mailOptions = {
            from: process.env.EMAIL,
            to: email,
            subject: 'Password Reset Code',
            text: `Your password reset code is ${resetCode}. It will expire in 15 minutes.`,
        };

        await transporter.sendMail(mailOptions);

        res.json({ message: 'Reset code sent to your email.' });
    } catch (err) {
        console.error('Forgot Password Error:', err);
        res.status(500).json({ error: 'Failed to send reset code' });
    }
});

// Reset Password
router.post('/reset-password', async (req, res) => {
    const { email, code, newPassword } = req.body;

    try {
        const user = await User.findOne({ email });
        if (!user) {
            return res.status(404).json({ error: 'User not found' });
        }

        console.log(`Retrieved reset code for user ${email}: ${user.resetCode}`);

        if (user.resetCode !== code) {
            console.log(`Reset code mismatch for user ${email}: Entered ${code}, Expected ${user.resetCode}`);
            return res.status(400).json({ error: 'Invalid reset code' });
        }

        if (user.resetCodeExpiry < Date.now()) {
            return res.status(400).json({ error: 'Reset code has expired' });
        }

        user.password = await argon2.hash(newPassword);
        user.resetCode = null;
        user.resetCodeExpiry = null;
        await user.save();

        console.log(`Password reset successful for user ${email}`);
        res.json({ message: 'Password reset successful' });
    } catch (err) {
        console.error('Reset Password Error:', err);
        res.status(500).json({ error: 'Failed to reset password' });
    }
});

// Login User
router.post('/login', async (req, res) => {
    const { email, password } = req.body;
    try {
        const user = await User.findOne({ email });
        if (!user) {
            console.error(`Login failed: User not found for email: ${email}`);
            return res.status(400).json({ error: 'Invalid credentials' });
        }

        console.log(`Login attempt for user: ${email}`);
        const isMatch = await argon2.verify(user.password, password);
        if (!isMatch) {
            console.error(`Password mismatch for user: ${email}`);
            return res.status(400).json({ error: 'Invalid credentials' });
        }

        if (!user.isVerified) {
            console.error(`Email not verified for user: ${email}`);
            return res.status(400).json({ error: 'Email not verified' });
        }

        const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, { expiresIn: '1h' });
        console.log(`Generated token for user ${email}: ${token}`);
        res.json({ token });
    } catch (error) {
        console.error('Login Error:', error);
        res.status(500).json({ error: 'Login failed' });
    }
});

module.exports = router;
