import { OrderService } from '../application/services/OrderService';
import { OrderRepository } from '../domain/repositories/OrderRepository';
import { Order, OrderStatus } from '../domain/models/Order';
import { OrderRequestDTO, OrderUpdateDTO, OrderResponseDTO } from '../domain/models/Order';

class MockOrderRepository implements OrderRepository {
  private orders: Map<string, Order> = new Map();

  async save(orderRequest: OrderRequestDTO): Promise<Order> {
    const id = `order-${Date.now()}`;
    const order: Order = {
      id,
      description: orderRequest.description,
      status: OrderStatus.PENDING,
      createdAt: new Date().toISOString()
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
      createdAt: existing.createdAt
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

  clear(): void {
    this.orders.clear();
  }
}

describe('OrderService', () => {
  let orderService: OrderService;
  let mockRepository: MockOrderRepository;

  beforeEach(() => {
    mockRepository = new MockOrderRepository();
    orderService = new OrderService(mockRepository);
  });

  afterEach(() => {
    mockRepository.clear();
  });

  describe('createOrder', () => {
    it('debería crear una orden exitosamente', async () => {
      const request: OrderRequestDTO = { description: 'Test Order' };
      const result = await orderService.createOrder(request);

      expect(result).toBeDefined();
      expect(result.description).toBe('Test Order');
      expect(result.status).toBe(OrderStatus.PENDING);
      expect(result.id).toBeDefined();
      expect(result.createdAt).toBeDefined();
    });

    it('debería lanzar error si la descripción está vacía', async () => {
      const request: OrderRequestDTO = { description: '' };

      await expect(orderService.createOrder(request)).rejects.toThrow();
    });
  });

  describe('getOrder', () => {
    it('debería obtener una orden por id', async () => {
      const created = await orderService.createOrder({ description: 'Test' });
      const result = await orderService.getOrder(created.id);

      expect(result.id).toBe(created.id);
      expect(result.description).toBe(created.description);
    });

    it('debería lanzar error si la orden no existe', async () => {
      await expect(orderService.getOrder('non-existent-id')).rejects.toThrow('Order not found');
    });
  });

  describe('updateOrder', () => {
    it('debería actualizar una orden exitosamente', async () => {
      const created = await orderService.createOrder({ description: 'Original' });
      const updateData: OrderUpdateDTO = { description: 'Updated', status: OrderStatus.COMPLETED };

      const result = await orderService.updateOrder(created.id, updateData);

      expect(result.description).toBe('Updated');
      expect(result.status).toBe(OrderStatus.COMPLETED);
    });

    it('debería lanzar error si la orden no existe', async () => {
      const updateData: OrderUpdateDTO = { description: 'Updated' };

      await expect(orderService.updateOrder('non-existent-id', updateData)).rejects.toThrow('Order not found');
    });
  });

  describe('deleteOrder', () => {
    it('debería eliminar una orden exitosamente', async () => {
      const created = await orderService.createOrder({ description: 'To Delete' });

      await expect(orderService.deleteOrder(created.id)).resolves.not.toThrow();

      await expect(orderService.getOrder(created.id)).rejects.toThrow('Order not found');
    });

    it('debería lanzar error si la orden no existe', async () => {
      await expect(orderService.deleteOrder('non-existent-id')).rejects.toThrow('Order not found');
    });
  });

  describe('listOrders', () => {
    it('debería listar todas las ordenes', async () => {
      await orderService.createOrder({ description: 'Order 1' });
      await orderService.createOrder({ description: 'Order 2' });

      const result = await orderService.listOrders();

      expect(result).toHaveLength(2);
    });

    it('debería retornar array vacío si no hay ordenes', async () => {
      const result = await orderService.listOrders();

      expect(result).toHaveLength(0);
    });
  });
});