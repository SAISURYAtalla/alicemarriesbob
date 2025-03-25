import express from 'express';
import { authMiddleware } from '../middleware/auth.js'; 
import { Account, Transaction } from '../db.js'; 
import mongoose from 'mongoose';
import PDFDocument from 'pdfkit';

const router = express.Router();

router.get('/balance', authMiddleware, async (req, res) => {
    const account = await Account.findOne({
        userId: req.userId
    });

    res.json({
        balance: account.balance
    });
});

router.post('/transfer', authMiddleware, async (req, res) => {
    const session = await mongoose.startSession();

    try {
        session.startTransaction();
        const { amount, to } = req.body;

        const account = await Account.findOne({ userId: req.userId }).session(session);
        if (!account || account.balance < amount) {
            await session.abortTransaction();
            return res.status(400).json({
                message: 'Insufficient balance'
            });
        }

        // Fetch recipient's account
        const toAccount = await Account.findOne({ userId: to }).session(session);
        if (!toAccount) {
            await session.abortTransaction();
            return res.status(400).json({
                message: 'Invalid account'
            });
        }

        // Update balances
        await Account.updateOne({ userId: req.userId }, { $inc: { balance: -amount } }).session(session);
        await Account.updateOne({ userId: to }, { $inc: { balance: amount } }).session(session);

        // Create transaction record
        await Transaction.create([{
            senderId: req.userId,
            receiverId: to,
            amount: amount
        }], { session });

        // Commit the transaction
        await session.commitTransaction();
        res.json({
            message: 'Transfer successful'
        });
    } catch (error) {
        await session.abortTransaction();
        res.status(500).json({
            message: 'Transfer failed due to an error',
            error: error.message
        });
    } finally {
        session.endSession();
    }
});

router.get('/transactions/pdf', authMiddleware, async (req, res) => {
    try {
        console.log('User ID:', req.userId);
        const transactions = await Transaction.find({
            $or: [{ senderId: req.userId }, { receiverId: req.userId }]
        }).populate('senderId receiverId', 'username firstName lastName');

        // Create PDF with password protection
        const doc = new PDFDocument({
            userPassword: process.env.PDF_PASSWORD, // Password to open the PDF
            ownerPassword: process.env.PDF_PASSWORD, // Optional: allows full access (can be different)
            permissions: { // Optional: restrict actions
                printing: 'highResolution',
                modifying: false,
                copying: false,
                annotating: false,
                fillingForms: false,
                contentAccessibility: false,
                documentAssembly: false
            }
        });

        res.setHeader('Content-Type', 'application/pdf');
        res.setHeader('Content-Disposition', 'attachment; filename="transactions.pdf"');
        doc.pipe(res);

        // PDF content
        doc.fontSize(16).text('Transaction History', { align: 'center' });
        doc.moveDown();
        doc.fontSize(12);

        if (!transactions.length) {
            doc.text('There are no transactions.', { align: 'center' });
        } else {
            transactions.forEach((tx, index) => {
                const sender = `${tx.senderId.firstName} ${tx.senderId.lastName}`;
                const receiver = `${tx.receiverId.firstName} ${tx.receiverId.lastName}`;
                doc.text(`${index + 1}. Amount: ${tx.amount}`);
                doc.text(`   From: ${sender} (${tx.senderId.username})`);
                doc.text(`   To: ${receiver} (${tx.receiverId.username})`);
                doc.text(`   Date: ${new Date(tx.createdAt).toLocaleString()}`);
                doc.moveDown();
            });
        }

        doc.end();
    } catch (error) {
        console.error('PDF Error:', error);
        res.status(500).json({ message: 'Error generating PDF', error: error.message });
    }
});

export default router;