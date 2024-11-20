const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema({
    name: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    isVerified: { type: Boolean, default: false },
    currentBalance: { type: Number, default: 0 }, 
    availableBalance: { type: Number, default: 0 }, 
    resetCode: { type: String },
    resetCodeExpiry: { type: Date },
    verificationCode: { type: Number },
});

module.exports = mongoose.model('User', UserSchema);
