package src.infrastructure.repositories;

import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, PutCommand, GetCommand, UpdateCommand, DeleteCommand, ScanCommand } from '@aws-sdk/lib-dynamodb';
import { Order, OrderRequestDTO, OrderUpdateDTO, OrderStatus, OrderResponseDTO } from '../../domain/models/Order';
import { OrderRepository } from '../../domain/repositories/OrderRepository';
import { v4 as uuidv4 } from 'uuid';

const TABLE_NAME = process.env.DYNAMODB_TABLE_NAME || 'Orders';

class DynamoOrderRepository implements OrderRepository {
    private readonly client: DynamoDBDocumentClient;

    constructor() {
        const dynamoDBClient = new DynamoDBClient({
            region: process.env.AWS_REGION || 'us-east-1',
            endpoint: process.env.DYNAMODB_ENDPOINT
        });
        this.client = DynamoDBDocumentClient.from(dynamoDBClient);
    }

    async save(orderRequest: OrderRequestDTO): Promise<Order> {
        const orderId = uuidv4();
        const createdAt = new Date().toISOString();
        const order = new Order(orderId, orderRequest.description, OrderStatus.PENDING, createdAt);

        const params = {
            TableName: TABLE_NAME,
            Item: {
                id: orderId,
                description: orderRequest.description,
                status: order.status,
                createdAt: createdAt
            }
        };

        await this.client.send(new PutCommand(params));
        return order;
    }

    async findById(id: string): Promise<Order | null> {
        const params = {
            TableName: TABLE_NAME,
            Key: { id }
        };

        const result = await this.client.send(new GetCommand(params));
        if (!result.Item) {
            return null;
        }

        return new Order(
            result.Item.id,
            result.Item.description,
            result.Item.status as OrderStatus,
            result.Item.createdAt
        );
    }

    async update(id: string, orderUpdate: OrderUpdateDTO): Promise<Order | null> {
        const existingOrder = await this.findById(id);
        if (!existingOrder) {
            return null;
        }

        const updateExpressionParts = [];
        const expressionAttributeValues: Record<string, any> = {};

        if (orderUpdate.description !== undefined) {
            updateExpressionParts.push('description = :description');
            expressionAttributeValues[':description'] = orderUpdate.description;
        }

        if (orderUpdate.status !== undefined) {
            updateExpressionParts.push('status = :status');
            expressionAttributeValues[':status'] = orderUpdate.status;
        }

        if (updateExpressionParts.length === 0) {
            return existingOrder;
        }

        const updateExpression = 'SET ' + updateExpressionParts.join(', ');

        const params = {
            TableName: TABLE_NAME,
            Key: { id },
            UpdateExpression: updateExpression,
            ExpressionAttributeValues: expressionAttributeValues,
            ReturnValues: 'ALL_NEW'
        };

        const result = await this.client.send(new UpdateCommand(params));
        if (!result.Attributes) {
            return null;
        }

        return new Order(
            result.Attributes.id,
            result.Attributes.description,
            result.Attributes.status as OrderStatus,
            result.Attributes.createdAt
        );
    }

    async delete(id: string): Promise<boolean> {
        const params = {
            TableName: TABLE_NAME,
            Key: { id }
        };

        try {
            await this.client.send(new DeleteCommand(params));
            return true;
        } catch (error) {
            return false;
        }
    }

    async list(): Promise<Order[]> {
        const params = {
            TableName: TABLE_NAME
        };

        const result = await this.client.send(new ScanCommand(params));
        if (!result.Items) {
            return [];
        }

        return result.Items.map(item => new Order(
            item.id,
            item.description,
            item.status as OrderStatus,
            item.createdAt
        ));
    }
}

export { DynamoOrderRepository };