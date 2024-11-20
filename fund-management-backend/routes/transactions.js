const express = require('express');
const authMiddleware = require('../middleware/authMiddleware');
const User = require('../models/User');
const Transaction = require('../models/Transaction');

const router = express.Router();

// Deposit Funds
router.post('/deposit', authMiddleware, async (req, res) => {
    const { amount } = req.body;

    if (!amount || isNaN(amount)) {
        return res.status(400).json({ error: 'Invalid amount' });
    }

    try {
        const user = await User.findById(req.user.id);
        if (!user) {
            return res.status(404).json({ error: 'User not found' });
        }

        // Update balance
        user.currentBalance += parseFloat(amount);
        user.availableBalance += parseFloat(amount); // Assuming availableBalance updates similarly
        await user.save();

        // Log transaction
        const transaction = new Transaction({
            user: user._id,
            type: 'deposit',
            amount: parseFloat(amount),
        });
        await transaction.save();

        console.log(`Deposit successful: User ${user.email}, Amount: $${amount}`);

        res.json({
            message: 'Deposit successful',
            currentBalance: user.currentBalance,
            availableBalance: user.availableBalance,
        });
    } catch (error) {
        console.error('Deposit Error:', error);
        res.status(500).json({ error: 'Deposit failed' });
    }
});



// Withdraw Funds
router.post('/withdraw', authMiddleware, async (req, res) => {
    const { amount } = req.body;
  
    if (!amount || isNaN(amount) || amount <= 0) {
      return res.status(400).json({ error: 'Invalid or zero amount' });
    }
  
    try {
      const user = await User.findById(req.user.id);
      if (!user) {
        return res.status(404).json({ error: 'User not found' });
      }
  
      if (user.availableBalance < amount) {
        return res.status(400).json({ error: 'Insufficient balance' });
      }
  
      user.currentBalance -= parseFloat(amount);
      user.availableBalance -= parseFloat(amount);
      await user.save();
  
      const transaction = new Transaction({
        user: user._id,
        type: 'withdraw',
        amount,
        date: new Date(),
      });
  
      await transaction.save();
  
      res.json({
        message: 'Withdrawal successful',
        currentBalance: user.currentBalance,
        availableBalance: user.availableBalance,
      });
    } catch (error) {
      console.error('Withdraw Error:', error);
      res.status(500).json({ error: 'Withdrawal failed' });
    }
  });
  


// Transfer 
router.post('/transfer', authMiddleware, async (req, res) => {
    const { amount, recipientEmail } = req.body;

    // Validate request
    if (!amount || isNaN(amount) || amount <= 0 || !recipientEmail) {
        return res.status(400).json({ error: 'Invalid transfer data.' });
    }

    try {
        const sender = await User.findById(req.user.id);

        // Check if the sender is trying to transfer to themselves
        if (sender.email === recipientEmail) {
            console.error(`Transfer failed: Sender ${sender.email} attempted to transfer to themselves.`);
            return res.status(400).json({ error: 'You cannot transfer funds to yourself.' });
        }

        const recipient = await User.findOne({ email: recipientEmail });

        if (!recipient) {
            console.error(`Transfer failed: Recipient ${recipientEmail} not found.`);
            return res.status(404).json({ error: 'Recipient not found.' });
        }

        if (sender.availableBalance < parseFloat(amount)) {
            console.error(
                `Transfer failed: Insufficient balance. Sender: ${sender.email}, Available: ${sender.currentBalance}, Requested: ${amount}`
            );
            return res.status(400).json({ error: 'Insufficient balance.' });
        }

        // Update balances
        sender.currentBalance -= parseFloat(amount);
        sender.availableBalance -= parseFloat(amount);
        recipient.currentBalance += parseFloat(amount);
        recipient.availableBalance += parseFloat(amount);
        await sender.save();
        await recipient.save();

        // Create transfer transaction
        const transaction = new Transaction({
            user: sender._id,
            type: 'Send Money',
            amount: parseFloat(amount),
            recipient: recipient._id,
        });
        await transaction.save();
        const transaction2 = new Transaction({
            user: recipient._id,
            type: 'Receive Money',
            amount: parseFloat(amount),
            recipient: recipient._id,
        });
        await transaction2.save();

        console.log(
            `Transfer successful: Sender ${sender.email}, Recipient ${recipient.email}, Amount: $${amount}`
        );

        res.json({
            message: 'Transfer successful.',
            balance: sender.currentBalance,
        });
    } catch (error) {
        console.error('Transfer Error:', error);
        res.status(500).json({ error: 'Transfer failed.' });
    }
});




module.exports = router;
