import { Request, Response, NextFunction } from 'express';
import { OrderService } from '../../application/services/OrderService';
import { OrderRequestDTO, OrderUpdateDTO } from '../../domain/models/Order';
import { NotFoundError } from '../middlewares/errorHandler';

export class OrderController {
  constructor(private readonly orderService: OrderService) {}

  async createOrder(req: Request, res: Response, _next: NextFunction): Promise<void> {
    try {
      const orderRequest: OrderRequestDTO = req.body as OrderRequestDTO;
      const order = await this.orderService.createOrder(orderRequest);
      res.status(201).json(order);
    } catch (error) {
      const err = error as Error;
      res.status(400).json({ error: err.message });
    }
  }

  async getOrder(req: Request, res: Response, _next: NextFunction): Promise<void> {
    try {
      const id = req.params.id;
      const order = await this.orderService.getOrder(id);
      
      if (!order) {
        throw new NotFoundError(`Orden con ID ${id} no encontrada`);
      }
      
      res.status(200).json(order);
    } catch (error) {
      const err = error as Error;
      res.status(404).json({ error: err.message });
    }
  }

  async updateOrder(req: Request, res: Response, _next: NextFunction): Promise<void> {
    try {
      const id = req.params.id;
      const updateData: OrderUpdateDTO = req.body as OrderUpdateDTO;
      const order = await this.orderService.updateOrder(id, updateData);
      
      if (!order) {
        throw new NotFoundError(`Orden con ID ${id} no encontrada`);
      }
      
      res.status(200).json(order);
    } catch (error) {
      const err = error as Error;
      res.status(404).json({ error: err.message });
    }
  }

  async deleteOrder(req: Request, res: Response, _next: NextFunction): Promise<void> {
    try {
      const id = req.params.id;
      await this.orderService.deleteOrder(id);
      res.status(204).send();
    } catch (error) {
      const err = error as Error;
      res.status(404).json({ error: err.message });
    }
  }

  async listOrders(req: Request, res: Response, _next: NextFunction): Promise<void> {
    try {
      const orders = await this.orderService.listOrders();
      res.status(200).json(orders);
    } catch (error) {
      const err = error as Error;
      res.status(500).json({ error: err.message });
    }
  }
}