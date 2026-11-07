import express, { Application, Request, Response, NextFunction } from 'express';
import { OrderController } from './infrastructure/controllers/OrderController';
import { errorHandler } from './infrastructure/middlewares/errorHandler';
import { validationMiddleware } from './infrastructure/middlewares/validation';
import { OrderRequestDTO, OrderUpdateDTO } from './domain/models/Order';
import { OrderService } from './application/services/OrderService';
import { createOrderRepository } from './infrastructure/repositories/OrderRepository';

export const app: Application = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

const orderRepository = createOrderRepository();
const orderService = new OrderService(orderRepository);
const orderController = new OrderController(orderService);

app.get('/health', (_req: Request, res: Response) => {
  res.status(200).json({ status: 'OK', message: 'Servidor funcionando correctamente' });
});

app.post('/orders', validationMiddleware(OrderRequestDTO), (req: Request, res: NextFunction) => {
  orderController.createOrder(req as any, res as any);
});

app.get('/orders', (req: Request, res: NextFunction) => {
  orderController.listOrders(req as any, res as any);
});

app.get('/orders/:id', (req: Request, res: NextFunction) => {
  orderController.getOrder(req as any, res as any);
});

app.put('/orders/:id', validationMiddleware(OrderUpdateDTO), (req: Request, res: NextFunction) => {
  orderController.updateOrder(req as any, res as any);
});

app.delete('/orders/:id', (req: Request, res: NextFunction) => {
  orderController.deleteOrder(req as any, res as any);
});

app.use(errorHandler);