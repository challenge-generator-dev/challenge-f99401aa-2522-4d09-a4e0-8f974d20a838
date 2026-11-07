import { Request, Response, NextFunction, ErrorRequestHandler } from 'express';

export class AppError extends Error {
    public readonly statusCode: number;
    public readonly isOperational: boolean;

    constructor(message: string, statusCode: number) {
        super(message);
        this.statusCode = statusCode;
        this.isOperational = true;
        
        Object.setPrototypeOf(this, AppError.prototype);
    }
}

export class NotFoundError extends AppError {
    constructor(message: string = 'Recurso no encontrado') {
        super(message, 404);
    }
}

export class ValidationError extends AppError {
    constructor(message: string = 'Error de validación') {
        super(message, 400);
    }
}

export class ConflictError extends AppError {
    constructor(message: string = 'Conflicto de datos') {
        super(message, 409);
    }
}

export class InternalServerError extends AppError {
    constructor(message: string = 'Error interno del servidor') {
        super(message, 500);
    }
}

export const errorHandler: ErrorRequestHandler = (
    err: Error,
    req: Request,
    res: Response,
    next: NextFunction
): void => {
    console.error('Error detectado:', {
        message: err.message,
        stack: err.stack,
        path: req.path,
        method: req.method,
        timestamp: new Date().toISOString(),
    });

    if (err instanceof AppError) {
        res.status(err.statusCode).json({
            error: err.message,
            statusCode: err.statusCode,
            timestamp: new Date().toISOString(),
            path: req.path,
        });
        return;
    }

    if (err.name === 'ValidationError') {
        res.status(400).json({
            error: 'Error de validación de datos',
            details: err.message,
            statusCode: 400,
            timestamp: new Date().toISOString(),
            path: req.path,
        });
        return;
    }

    if (err.name === 'CastError' || err.name === 'ObjectIdError') {
        res.status(400).json({
            error: 'ID inválido',
            statusCode: 400,
            timestamp: new Date().toISOString(),
            path: req.path,
        });
        return;
    }

    const internalError = new InternalServerError('Error interno del servidor');
    res.status(internalError.statusCode).json({
        error: internalError.message,
        statusCode: internalError.statusCode,
        timestamp: new Date().toISOString(),
        path: req.path,
    });
};

export const notFoundHandler = (req: Request, res: Response): void => {
    res.status(404).json({
        error: `Ruta no encontrada: ${req.method} ${req.originalUrl}`,
        statusCode: 404,
        timestamp: new Date().toISOString(),
        path: req.path,
    });
};