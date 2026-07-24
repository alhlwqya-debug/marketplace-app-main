import Stripe from 'stripe';
import { environment } from './environment';

export const stripe = new Stripe(environment.stripe.secretKey, {
  apiVersion: '2023-10-16',
});
