import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, DynamoDBDocumentClientConfig } from '@aws-sdk/lib-dynamodb';

const getClientConfig = (): DynamoDBClientConfig => {
    const region = process.env.AWS_REGION || 'us-east-1';
    const endpoint = process.env.DYNAMODB_ENDPOINT;
    const credentials = process.env.AWS_ACCESS_KEY_ID && process.env.AWS_SECRET_ACCESS_KEY
        ? {
            accessKeyId: process.env.AWS_ACCESS_KEY_ID,
            secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
          }
        : undefined;

    const config: DynamoDBClientConfig = {
        region,
    };

    if (endpoint) {
        config.endpoint = endpoint;
    }

    if (credentials) {
        config.credentials = credentials;
    }

    return config;
};

const createDocumentClient = (): DynamoDBDocumentClient => {
    const clientConfig = getClientConfig();
    const client = new DynamoDBClient(clientConfig);

    const documentClientConfig: DynamoDBDocumentClientConfig = {
        client,
        marshallOptions: {
            removeUndefinedValues: true,
            convertClassInstanceToMap: true,
        },
        unmarshallOptions: {
            wrapNumbers: false,
        },
    };

    return DynamoDBDocumentClient.from(client, documentClientConfig);
};

let documentClientInstance: DynamoDBDocumentClient | null = null;

export const getDynamoDocumentClient = (): DynamoDBDocumentClient => {
    if (!documentClientInstance) {
        documentClientInstance = createDocumentClient();
    }
    return documentClientInstance;
};

export const getTableName = (): string => {
    return process.env.DYNAMODB_TABLE_NAME || 'orders';
};

export const initializeDynamoConfig = (): void => {
    const requiredEnvVars = ['AWS_REGION'];
    const missingVars = requiredEnvVars.filter(envVar => !process.env[envVar]);
    
    if (missingVars.length > 0) {
        console.warn(`Advertencia: Las siguientes variables de entorno no están configuradas: ${missingVars.join(', ')}. Se usarán valores por defecto.`);
    }
};