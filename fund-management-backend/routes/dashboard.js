const express = require('express');
const authMiddleware = require('../middleware/authMiddleware');
const User = require('../models/User');
const Transaction = require('../models/Transaction');

const router = express.Router();

// Get Dashboard Data
router.get('/dashboard', authMiddleware, async (req, res) => {
    try {
        const user = await User.findById(req.user.id).select('-password');
        if (!user) {
            return res.status(404).json({ error: 'User not found' });
        }

        const transactions = await Transaction.find({ user: req.user.id })
            .sort({ date: -1 })
            .limit(10); // Fetch last 10 transactions

        res.json({
            currentBalance: user.currentBalance,
            availableBalance: user.availableBalance,
            transactions: transactions.map((transaction) => ({
                id: transaction._id,
                type: transaction.type,
                amount: transaction.amount,
                date: transaction.date,
                recipient: transaction.recipient, // Optional for transfers
            })),
        });
    } catch (error) {
        console.error('Dashboard Error:', error);
        res.status(500).json({ error: 'Failed to fetch dashboard data' });
    }
});




module.exports = router;
