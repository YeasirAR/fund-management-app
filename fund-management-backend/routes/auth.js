const express = require('express');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const User = require('../models/User');
const sendEmail = require('../utils/sendEmail');

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
        const hashedPassword = await bcrypt.hash(password, 10);

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
        if (!user || user.verificationCode !== code) {
            return res.status(400).json({ error: 'Invalid verification code' });
        }

        user.isVerified = true;
        user.verificationCode = null;
        await user.save();

        res.json({ message: 'Email verified successfully' });
    } catch (error) {
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

        const resetCode = Math.floor(100000 + Math.random() * 900000);
        user.resetCode = resetCode;
        await user.save();

        await sendEmail(
            email,
            'Password Reset Code',
            `Your password reset code is: ${resetCode}`
        );

        res.json({ message: 'Reset code sent to email.' });
    } catch (error) {
        res.status(500).json({ error: 'Failed to send reset code' });
    }
});

// Reset Password
router.post('/reset-password', async (req, res) => {
    const { email, code, newPassword } = req.body;

    try {
        const user = await User.findOne({ email });
        if (!user || user.resetCode !== code) {
            return res.status(400).json({ error: 'Invalid reset code' });
        }

        user.password = await bcrypt.hash(newPassword, 10);
        user.resetCode = null;
        await user.save();

        res.json({ message: 'Password reset successfully' });
    } catch (error) {
        res.status(500).json({ error: 'Password reset failed' });
    }
});

// Login User
router.post('/login', async (req, res) => {
    const { email, password } = req.body;
    try {
        const user = await User.findOne({ email });
        if (!user) return res.status(400).json({ error: 'Invalid credentials' });

        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) return res.status(400).json({ error: 'Invalid credentials' });
        if (!user.isVerified) return res.status(400).json({ error: 'Email not verified' });
        const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, { expiresIn: '1h' });
        res.json({ token });
    } catch (error) {
        console.error('Login Error:', error);
        res.status(500).json({ error: 'Login failed' });
    }
});

module.exports = router;
