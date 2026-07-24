import * as admin from 'firebase-admin';
import * as fs from 'fs';
import * as path from 'path';

admin.initializeApp();

const db = admin.firestore();

const backupDatabase = async (backupDir: string = './backups') => {
  const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
  const backupPath = path.join(backupDir, `backup_${timestamp}.json`);

  if (!fs.existsSync(backupDir)) {
    fs.mkdirSync(backupDir, { recursive: true });
  }

  const backup: any = {};
  const collections = ['users', 'stores', 'products', 'orders', 'reviews', 'categories'];

  for (const collection of collections) {
    console.log(`📦 Backing up ${collection}...`);
    const snapshot = await db.collection(collection).get();
    backup[collection] = {};

    snapshot.forEach(doc => {
      backup[collection][doc.id] = {
        ...doc.data(),
        _backupTimestamp: new Date().toISOString(),
      };
    });
  }

  fs.writeFileSync(backupPath, JSON.stringify(backup, null, 2));
  console.log(`✅ Backup saved to: ${backupPath}`);
  console.log(`📊 Total collections: ${collections.length}`);
  console.log(`📊 Total documents: ${Object.values(backup).reduce((sum: number, col: any) => sum + Object.keys(col).length, 0)}`);

  return backupPath;
};

if (require.main === module) {
  backupDatabase().catch(console.error);
}

export { backupDatabase };
