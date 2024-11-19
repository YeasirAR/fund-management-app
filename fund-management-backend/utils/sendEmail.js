const nodemailer = require('nodemailer');

const sendEmail = async (to, subject, text) => {
    try {
        // Create transporter with email service and authentication details
        const transporter = nodemailer.createTransport({
            service: 'Gmail', // Use your email provider, e.g., 'Gmail', 'Outlook', etc.
            auth: {
                user: process.env.EMAIL, // Sender email from .env
                pass: process.env.EMAIL_PASSWORD, // App password from .env
            },
        });

        // Email options
        const mailOptions = {
            from: process.env.EMAIL, // Sender address
            to, // Recipient email
            subject, // Email subject
            text, // Email body text
        };

        const info = await transporter.sendMail(mailOptions);
        console.log(`Email sent: ${info.response}`); 
    } catch (error) {
        console.error(`Error sending email: ${error.message}`); 
        throw error; 
    }
};

module.exports = sendEmail;
