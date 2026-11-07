import { OrderStatus } from '../../../domain/models/Order';

export { OrderStatus } from '../../../domain/models/Order';

export interface OrderRequestDTO {
  description: string;
}

export interface OrderUpdateDTO {
  description?: string;
  status?: OrderStatus;
}

export interface OrderResponseDTO {
  id: string;
  description: string;
  status: OrderStatus;
  createdAt: string;
}