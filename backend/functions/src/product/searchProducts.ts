import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

export const searchProducts = functions.https.onCall(async (data, context) => {
  const { query, category, minPrice, maxPrice, sortBy = 'relevance', limit = 20 } = data;

  let productsQuery: admin.firestore.Query = admin.firestore()
    .collection('products')
    .where('isActive', '==', true);

  // Apply category filter
  if (category) {
    productsQuery = productsQuery.where('category', '==', category);
  }

  // Apply price filters
  if (minPrice !== undefined) {
    productsQuery = productsQuery.where('price', '>=', minPrice);
  }
  if (maxPrice !== undefined) {
    productsQuery = productsQuery.where('price', '<=', maxPrice);
  }

  // Apply sorting
  switch (sortBy) {
    case 'price_asc':
      productsQuery = productsQuery.orderBy('price', 'asc');
      break;
    case 'price_desc':
      productsQuery = productsQuery.orderBy('price', 'desc');
      break;
    case 'rating':
      productsQuery = productsQuery.orderBy('rating', 'desc');
      break;
    case 'newest':
      productsQuery = productsQuery.orderBy('createdAt', 'desc');
      break;
    default:
      productsQuery = productsQuery.orderBy('rating', 'desc');
  }

  const snapshot = await productsQuery.limit(limit).get();

  const products = snapshot.docs.map(doc => {
    const data = doc.data();
    return {
      productId: doc.id,
      ...data,
      createdAt: data.createdAt?.toDate()?.toISOString(),
    };
  });

  // Simple text search (for production, use Algolia)
  let results = products;
  if (query) {
    const searchTerm = query.toLowerCase();
    results = products.filter(p => 
      p.name?.toLowerCase().includes(searchTerm) ||
      p.description?.toLowerCase().includes(searchTerm) ||
      p.tags?.some((tag: string) => tag.toLowerCase().includes(searchTerm))
    );
  }

  return { products: results, total: results.length };
});
