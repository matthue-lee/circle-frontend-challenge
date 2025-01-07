import express from 'express';
import booksRouter from './router/booksRouter';
import { errorHandler } from './middleware/errorHandler';
import ErrorHandler from './utils/ErrorHandler';
import cors from 'cors';
import dotenv from 'dotenv';

dotenv.config();

const app = express();

// Use the PORT environment variable if available, otherwise default to 8000
const port = process.env.PORT || 8000;

app.use(express.json());
app.use(cors({
    origin: ['http://localhost:5173', 'https://circle-pos-front.vercel.app/'], // Replace with your actual frontend URL
}));

app.use('/books', booksRouter);

app.use((_req, _res, next) => {
    next(new ErrorHandler('Route not found', 404));
});

app.use(errorHandler);

app.listen(port, () => {
    console.log(`🚀 Example app listening at http://localhost:${port}`);
});
