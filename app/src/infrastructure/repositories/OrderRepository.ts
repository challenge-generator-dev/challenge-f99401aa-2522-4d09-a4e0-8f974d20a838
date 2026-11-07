import { OrderRepository } from '../../domain/repositories/OrderRepository';
import { OrderRequestDTO, OrderUpdateDTO, Order } from '../../domain/models/Order';

// Implementación de repositorio en memoria para desarrollo local
// En producción, usar DynamoOrderRepository que implementa OrderRepository
export class InMemoryOrderRepository implements OrderRepository {
  private orders: Map<string, Order> = new Map();

  async save(orderRequest: OrderRequestDTO): Promise<Order> {
    const id = orderRequest.id || crypto.randomUUID();
    const order: Order = {
      id,
      description: orderRequest.description,
      status: orderRequest.status || 'PENDING',
      createdAt: orderRequest.createdAt || new Date().toISOString(),
    };
    this.orders.set(id, order);
    return order;
  }

  async findById(id: string): Promise<Order | null> {
    return this.orders.get(id) || null;
  }

  async update(id: string, orderUpdate: OrderUpdateDTO): Promise<Order | null> {
    const existing = this.orders.get(id);
    if (!existing) {
      return null;
    }
    const updated: Order = {
      ...existing,
      ...orderUpdate,
      id: existing.id,
      createdAt: existing.createdAt,
    };
    this.orders.set(id, updated);
    return updated;
  }

  async delete(id: string): Promise<boolean> {
    return this.orders.delete(id);
  }

  async list(): Promise<Order[]> {
    return Array.from(this.orders.values());
  }
}

// Export factory para crear instancia según configuración
export function createOrderRepository(): OrderRepository {
  const useDynamo = process.env.USE_DYNAMODB === 'true';
  
  if (useDynamo) {
    // Dynamically import to avoid issues when DynamoDB is not configured
    const { DynamoOrderRepository } = require('./DynamoOrderRepository');
    return new DynamoOrderRepository();
  }
  
  return new InMemoryOrderRepository();
}

// Re-export interfaz del dominio para facilitar imports en otros módulos
export type { OrderRepository } from '../../domain/repositories/OrderRepository';