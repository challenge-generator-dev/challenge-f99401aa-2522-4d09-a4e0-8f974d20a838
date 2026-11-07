import 'dotenv/config';
import { app } from './app';
import { createOrderTable } from './infrastructure/config/dynamoConfig';

const PORT = process.env.PORT || 3000;

async function bootstrap(): Promise<void> {
  try {
    await createOrderTable();
    
    app.listen(PORT, () => {
      console.log(`Servidor corriendo en http://localhost:${PORT}`);
      console.log('Tabla DynamoDB verificada/creada exitosamente');
    });
  } catch (error) {
    console.error('Error al iniciar el servidor:', error);
    process.exit(1);
  }
}

bootstrap();