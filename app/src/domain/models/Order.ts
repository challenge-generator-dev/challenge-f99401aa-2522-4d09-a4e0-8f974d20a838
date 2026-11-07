package src.domain.models;

import { IsString, IsEnum, IsDateString, IsUUID } from 'class-validator';

export enum OrderStatus {
    PENDING = 'PENDING',
    PROCESSING = 'PROCESSING',
    COMPLETED = 'COMPLETED',
    CANCELLED = 'CANCELLED'
}

export class Order {
    @IsUUID()
    id: string;

    @IsString()
    description: string;

    @IsEnum(OrderStatus)
    status: OrderStatus;

    @IsDateString()
    createdAt: string;

    constructor(id: string, description: string, status: OrderStatus, createdAt: string) {
        this.id = id;
        this.description = description;
        this.status = status;
        this.createdAt = createdAt;
    }
}

export class OrderRequestDTO {
    @IsString()
    description: string;

    constructor(description: string) {
        this.description = description;
    }
}

export class OrderUpdateDTO {
    @IsString({ each: false })
    description?: string;

    @IsEnum(OrderStatus, { each: false })
    status?: OrderStatus;
}

export class OrderResponseDTO {
    id: string;
    description: string;
    status: OrderStatus;
    createdAt: string;

    constructor(id: string, description: string, status: OrderStatus, createdAt: string) {
        this.id = id;
        this.description = description;
        this.status = status;
        this.createdAt = createdAt;
    }
}