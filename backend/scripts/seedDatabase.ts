import * as admin from 'firebase-admin';
import * as fs from 'fs';

// Initialize admin SDK
admin.initializeApp();

const db = admin.firestore();

const seedData = async () => {
  console.log('🌱 Starting database seeding...');

  // Seed Categories
  const categories = [
    { name: 'ملابس', icon: 'checkroom', order: 1 },
    { name: 'إلكترونيات', icon: 'phone_android', order: 2 },
    { name: 'بيت', icon: 'home', order: 3 },
    { name: 'طعام', icon: 'restaurant', order: 4 },
    { name: 'سيارات', icon: 'directions_car', order: 5 },
    { name: 'جمال', icon: 'spa', order: 6 },
    { name: 'رياضة', icon: 'sports', order: 7 },
  ];

  const batch = db.batch();
  categories.forEach((cat, index) => {
    const ref = db.collection('categories').doc(`cat_${index}`);
    batch.set(ref, { ...cat, createdAt: admin.firestore.FieldValue.serverTimestamp() });
  });
  await batch.commit();
  console.log('✅ Categories seeded');

  // Seed Sample Products
  const sampleProducts = [
    {
      productId: 'prod_1',
      storeId: 'store_1',
      name: 'سماعات لاسلكية فاخرة',
      description: 'سماعات بلوتوث 5.3 مع إلغاء ضوضاء نشط، بطارية 30 ساعة',
      price: 199,
      discountPrice: 149,
      images: ['https://example.com/headphones.jpg'],
      category: 'إلكترونيات',
      tags: ['سماعات', 'بلوتوث', 'لاسلكي'],
      inventory: 50,
      rating: 4.8,
      reviewCount: 1234,
      isActive: true,
    },
    {
      productId: 'prod_2',
      storeId: 'store_1',
      name: 'قميص قطني 100%',
      description: 'قميص عالي الجودة من القطن الطبيعي',
      price: 79,
      images: ['https://example.com/shirt.jpg'],
      category: 'ملابس',
      tags: ['قميص', 'قطن', 'رجالي'],
      inventory: 100,
      rating: 4.5,
      reviewCount: 567,
      isActive: true,
    },
    {
      productId: 'prod_3',
      storeId: 'store_2',
      name: 'حذاء رياضي احترافي',
      description: 'حذاء رياضي مريح للجري والتمارين',
      price: 299,
      discountPrice: 249,
      images: ['https://example.com/shoes.jpg'],
      category: 'رياضة',
      tags: ['حذاء', 'رياضة', 'جري'],
      inventory: 30,
      rating: 4.7,
      reviewCount: 890,
      isActive: true,
    },
  ];

  for (const product of sampleProducts) {
    await db.collection('products').doc(product.productId).set({
      ...product,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });
  }
  console.log('✅ Products seeded');

  // Seed Sample Stores
  const sampleStores = [
    {
      storeId: 'store_1',
      ownerId: 'user_1',
      name: 'متجر التقنية',
      description: 'متجر متخصص في الإلكترونيات والأجهزة الذكية',
      category: 'إلكترونيات',
      rating: 4.9,
      followersCount: 1200,
      status: 'active',
    },
    {
      storeId: 'store_2',
      ownerId: 'user_2',
      name: 'متجر الرياضة',
      description: 'كل ما يحتاجه الرياضي',
      category: 'رياضة',
      rating: 4.6,
      followersCount: 800,
      status: 'active',
    },
  ];

  for (const store of sampleStores) {
    await db.collection('stores').doc(store.storeId).set({
      ...store,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });
  }
  console.log('✅ Stores seeded');

  console.log('🎉 Database seeding completed!');
};

// Run if called directly
if (require.main === module) {
  seedData().catch(console.error);
}

export { seedData };
