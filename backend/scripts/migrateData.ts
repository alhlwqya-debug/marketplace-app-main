import * as admin from 'firebase-admin';

admin.initializeApp();

const db = admin.firestore();

interface Migration {
  name: string;
  version: number;
  up: () => Promise<void>;
  down: () => Promise<void>;
}

const migrations: Migration[] = [
  {
    name: 'add_created_at_to_products',
    version: 1,
    up: async () => {
      const snapshot = await db.collection('products').get();
      const batch = db.batch();

      snapshot.forEach(doc => {
        if (!doc.data().createdAt) {
          batch.update(doc.ref, {
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
          });
        }
      });

      await batch.commit();
      console.log('✅ Migration 1 completed: Added createdAt to products');
    },
    down: async () => {
      console.log('⏪ Migration 1 rollback: No action needed');
    },
  },
  {
    name: 'add_status_to_orders',
    version: 2,
    up: async () => {
      const snapshot = await db.collection('orders').get();
      const batch = db.batch();

      snapshot.forEach(doc => {
        if (!doc.data().status) {
          batch.update(doc.ref, { status: 'pending' });
        }
      });

      await batch.commit();
      console.log('✅ Migration 2 completed: Added status to orders');
    },
    down: async () => {
      console.log('⏪ Migration 2 rollback: No action needed');
    },
  },
  {
    name: 'add_followers_count_to_stores',
    version: 3,
    up: async () => {
      const snapshot = await db.collection('stores').get();
      const batch = db.batch();

      snapshot.forEach(doc => {
        if (!doc.data().followersCount) {
          batch.update(doc.ref, { followersCount: 0 });
        }
      });

      await batch.commit();
      console.log('✅ Migration 3 completed: Added followersCount to stores');
    },
    down: async () => {
      console.log('⏪ Migration 3 rollback: No action needed');
    },
  },
];

const runMigrations = async (targetVersion?: number) => {
  const migrationRef = db.collection('migrations').doc('status');
  const status = await migrationRef.get();
  const currentVersion = status.exists ? status.data()?.version || 0 : 0;

  const target = targetVersion || migrations.length;

  if (target > currentVersion) {
    // Run up migrations
    for (const migration of migrations) {
      if (migration.version > currentVersion && migration.version <= target) {
        console.log(`🚀 Running migration: ${migration.name}`);
        await migration.up();
        await migrationRef.set({ version: migration.version, lastRun: admin.firestore.FieldValue.serverTimestamp() });
      }
    }
  } else if (target < currentVersion) {
    // Run down migrations
    for (const migration of [...migrations].reverse()) {
      if (migration.version <= currentVersion && migration.version > target) {
        console.log(`⏪ Rolling back migration: ${migration.name}`);
        await migration.down();
      }
    }
    await migrationRef.set({ version: target, lastRun: admin.firestore.FieldValue.serverTimestamp() });
  }

  console.log(`✅ Migrations complete. Current version: ${target}`);
};

if (require.main === module) {
  const targetVersion = process.argv[2] ? parseInt(process.argv[2]) : undefined;
  runMigrations(targetVersion).catch(console.error);
}

export { runMigrations, migrations };
