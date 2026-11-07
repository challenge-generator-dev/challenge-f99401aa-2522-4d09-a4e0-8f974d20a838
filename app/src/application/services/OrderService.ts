import { OrderRepository } from '../domain/repositories/OrderRepository';
import { OrderRequestDTO, OrderUpdateDTO, OrderResponseDTO, OrderStatus } from '../domain/models/Order';
import { NotFoundError } from '../../infrastructure/middlewares/errorHandler';
import { v4 as uuidv4 } from 'uuid';

export class OrderService {
  constructor(private readonly orderRepository: OrderRepository) {}

  async createOrder(request: OrderRequestDTO): Promise<OrderResponseDTO> {
    if (!request.description || request.description.trim().length === 0) {
      throw new Error('La descripción de la orden es requerida');
    }
    
    if (request.description.length > 500) {
      throw new Error('La descripción no puede exceder 500 caracteres');
    }

    const order = await this.orderRepository.save({
      description: request.description.trim()
    });

    return this.toResponseDTO(order);
  }

  async getOrder(id: string): Promise<OrderResponseDTO> {
    if (!id || id.trim().length === 0) {
      throw new Error('El ID de la orden es requerido');
    }

    const order = await this.orderRepository.findById(id);
    
    if (!order) {
      throw new NotFoundError(`Orden con ID ${id} no encontrada`);
    }

    return this.toResponseDTO(order);
  }

  async updateOrder(id: string, updateData: OrderUpdateDTO): Promise<OrderResponseDTO> {
    if (!id || id.trim().length === 0) {
      throw new Error('El ID de la orden es requerido');
    }

    if (updateData.description !== undefined) {
      if (updateData.description.trim().length === 0) {
        throw new Error('La descripción no puede estar vacía');
      }
      if (updateData.description.length > 500) {
        throw new Error('La descripción no puede exceder 500 caracteres');
      }
    }

    if (updateData.status !== undefined) {
      const validStatuses = [OrderStatus.PENDING, OrderStatus.PROCESSING, OrderStatus.COMPLETED, OrderStatus.CANCELLED];
      if (!validStatuses.includes(updateData.status)) {
        throw new Error(`Estado inválido: ${updateData.status}`);
      }
    }

    const updatedOrder = await this.orderRepository.update(id, updateData);
    
    if (!updatedOrder) {
      throw new NotFoundError(`Orden con ID ${id} no encontrada`);
    }

    return this.toResponseDTO(updatedOrder);
  }

  async deleteOrder(id: string): Promise<void> {
    if (!id || id.trim().length === 0) {
      throw new Error('El ID de la orden es requerido');
    }

    const deleted = await this.orderRepository.delete(id);
    
    if (!deleted) {
      throw new NotFoundError(`Orden con ID ${id} no encontrada`);
    }
  }

  async listOrders(): Promise<OrderResponseDTO[]> {
    const orders = await this.orderRepository.list();
    return orders.map(order => this.toResponseDTO(order));
  }

  private toResponseDTO(order: { id: string; description: string; status: OrderStatus; createdAt: string }): OrderResponseDTO {
    return {
      id: order.id,
      description: order.description,
      status: order.status,
      createdAt: order.createdAt
    };
  }
}