const nodemailer = require('nodemailer');

const sendEmail = async (to, subject, text) => {
    try {
        const transporter = nodemailer.createTransport({
            service: 'Gmail',
            auth: {
                user: process.env.EMAIL, 
                pass: process.env.EMAIL_PASSWORD, 
            },
        });

        const mailOptions = {
            from: process.env.EMAIL, 
            to,
            subject,
            text,
        };

        const info = await transporter.sendMail(mailOptions);
        console.log(`Email sent: ${info.response}`); 
    } catch (error) {
        console.error(`Error sending email: ${error.message}`); 
        throw error; 
    }
};

module.exports = sendEmail;
