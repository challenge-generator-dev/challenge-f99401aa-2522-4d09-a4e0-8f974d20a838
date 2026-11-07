package src.domain.repositories;

import { Order, OrderRequestDTO, OrderUpdateDTO } from '../models/Order';

export interface OrderRepository {
    save(order: OrderRequestDTO): Promise<Order>;
    findById(id: string): Promise<Order | null>;
    update(id: string, orderUpdate: OrderUpdateDTO): Promise<Order | null>;
    delete(id: string): Promise<boolean>;
    list(): Promise<Order[]>;
}