export const environment = {
  production: false,

  // ✅ Supabase Configuration
  supabase: {
    url: 'https://shofjkpvtgitelqvmatp.supabase.co',
    anonKey: 'sb_publishable_LtM9lVjFeOwcnRJV500E_Q_Vkxivib7',
    // Database connection string (for server-side operations)
    // postgresql://postgres:[YOUR-PASSWORD]@db.shofjkpvtgitelqvmatp.supabase.co:5432/postgres
  },

  // Firebase (for notifications only)
  firebase: {
    apiKey: "AIzaSyDKp2fjOTRR9gW50nFuxtzY-kqupckyggA",
    authDomain: "marketplace-app-c8d65.firebaseapp.com",
    projectId: "marketplace-app-c8d65",
    storageBucket: "marketplace-app-c8d65.firebasestorage.app",
    messagingSenderId: "750001991112",
    appId: "1:750001991112:android:b6d368e499c63aac23a4fd",
  },

  stripe: {
    secretKey: process.env.STRIPE_SECRET_KEY || '',
    webhookSecret: process.env.STRIPE_WEBHOOK_SECRET || '',
  },

  sendgrid: {
    apiKey: process.env.SENDGRID_API_KEY || '',
  },

  cloudinary: {
    cloudName: process.env.CLOUDINARY_CLOUD_NAME || '',
    apiKey: process.env.CLOUDINARY_API_KEY || '',
    apiSecret: process.env.CLOUDINARY_API_SECRET || '',
  },
};
