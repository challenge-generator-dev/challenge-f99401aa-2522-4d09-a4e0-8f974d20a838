import { Request, Response, NextFunction } from 'express';
import { body, param, validationResult, ValidationChain } from 'express-validator';

export const validateRequest = (validations: ValidationChain[]) => {
    return async (req: Request, res: Response, next: NextFunction): Promise<void> => {
        await Promise.all(validations.map(validation => validation.run(req)));
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            res.status(400).json({
                success: false,
                message: 'Validation failed',
                errors: errors.array().map(err => ({
                    field: 'path' in err ? err.path : 'unknown',
                    message: err.msg
                }))
            });
            return;
        }
        next();
    };
};

export const createOrderValidation = [
    body('description')
        .isString()
        .withMessage('Description must be a string')
        .notEmpty()
        .withMessage('Description is required')
        .isLength({ min: 1, max: 500 })
        .withMessage('Description must be between 1 and 500 characters')
        .trim()
        .escape()
];

export const orderIdValidation = [
    param('id')
        .isString()
        .withMessage('Order ID must be a string')
        .notEmpty()
        .withMessage('Order ID is required')
        .isUUID()
        .withMessage('Order ID must be a valid UUID')
];

export const updateOrderValidation = [
    param('id')
        .isString()
        .withMessage('Order ID must be a string')
        .notEmpty()
        .withMessage('Order ID is required')
        .isUUID()
        .withMessage('Order ID must be a valid UUID'),
    body('description')
        .optional()
        .isString()
        .withMessage('Description must be a string')
        .isLength({ min: 1, max: 500 })
        .withMessage('Description must be between 1 and 500 characters')
        .trim()
        .escape(),
    body('status')
        .optional()
        .isIn(['PENDING', 'PROCESSING', 'COMPLETED', 'CANCELLED'])
        .withMessage('Status must be one of: PENDING, PROCESSING, COMPLETED, CANCELLED')
];

export const listOrdersValidation: ValidationChain[] = [];