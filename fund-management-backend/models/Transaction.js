const mongoose = require('mongoose');

const TransactionSchema = new mongoose.Schema({
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    type: { type: String, enum: ['deposit', 'withdraw', 'Send Money','Receive Money'], required: true },
    amount: { type: Number, required: true },
    recipient: { type: mongoose.Schema.Types.ObjectId, ref: 'User' }, 
    date: { type: Date, default: Date.now },
});

module.exports = mongoose.model('Transaction', TransactionSchema);
