const express = require('express');
const authMiddleware = require('../middleware/authMiddleware');
const User = require('../models/User');
const Transaction = require('../models/Transaction');

const router = express.Router();

// Deposit Funds
router.post('/deposit', authMiddleware, async (req, res) => {
    const { amount } = req.body;
    try {
        const user = await User.findById(req.user.id);
        user.balance += amount;
        await user.save();

        const transaction = new Transaction({ user: user._id, type: 'deposit', amount });
        await transaction.save();

        res.json({ message: 'Deposit successful', balance: user.balance });
    } catch (error) {
        res.status(500).json({ error: 'Deposit failed' });
    }
});

// Withdraw Funds
router.post('/withdraw', authMiddleware, async (req, res) => {
    const { amount } = req.body;
    try {
        const user = await User.findById(req.user.id);
        if (user.balance < amount) return res.status(400).json({ error: 'Insufficient funds' });

        user.balance -= amount;
        await user.save();

        const transaction = new Transaction({ user: user._id, type: 'withdraw', amount });
        await transaction.save();

        res.json({ message: 'Withdrawal successful', balance: user.balance });
    } catch (error) {
        res.status(500).json({ error: 'Withdrawal failed' });
    }
});

// Transfer Funds
router.post('/transfer', authMiddleware, async (req, res) => {
    const { amount, recipientEmail } = req.body;
    try {
        const sender = await User.findById(req.user.id);
        const recipient = await User.findOne({ email: recipientEmail });
        if (!recipient) return res.status(404).json({ error: 'Recipient not found' });

        if (sender.balance < amount) return res.status(400).json({ error: 'Insufficient funds' });

        sender.balance -= amount;
        recipient.balance += amount;
        await sender.save();
        await recipient.save();

        const transaction = new Transaction({
            user: sender._id,
            type: 'transfer',
            amount,
            recipient: recipient._id,
        });
        await transaction.save();

        res.json({ message: 'Transfer successful', balance: sender.balance });
    } catch (error) {
        res.status(500).json({ error: 'Transfer failed' });
    }
});

module.exports = router;
