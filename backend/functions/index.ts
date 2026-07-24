import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

// Export all functions
export * from './src/auth/onUserCreated';
export * from './src/auth/onUserDeleted';
export * from './src/store/createStore';
export * from './src/store/verifyStore';
export * from './src/product/createProduct';
export * from './src/order/createOrder';
export * from './src/order/processPayment';
export * from './src/notification/sendPush';
