# Supabase Setup Guide for Marketplace App

## FREE TIER LIMITS
- Database: 500 MB
- Storage: 1 GB
- Bandwidth: 2 GB/month
- Auth: 50,000 users/month
- Real-time: 200 concurrent connections

## 1. Create Supabase Project
1. Go to https://supabase.com
2. Sign up with GitHub
3. Create new project: "marketplace-app"
4. Choose region: "Middle East (me-central-1)" for best performance
5. Save your Project URL and Anon Key

## 2. Run SQL Schema
1. Go to Supabase Dashboard → SQL Editor
2. Copy contents of `schema.sql`
3. Click "Run"

## 3. Create Storage Buckets
1. Go to Storage → New Bucket
2. Create these buckets:
   - `product-images` (Public)
   - `store-logos` (Public)
   - `user-avatars` (Private)
   - `review-images` (Public)

## 4. Update Flutter Code
Replace in `lib/services/supabase_service.dart`:
```dart
url: 'https://your-project.supabase.co',
anonKey: 'your-anon-key',
```

## 5. Enable Auth Providers
1. Go to Authentication → Providers
2. Enable:
   - Email
   - Phone (OTP)
   - Google (OAuth)
   - Apple (OAuth)

## 6. Configure RLS Policies
Policies are already in schema.sql, but verify:
- Storage buckets have correct RLS
- Database tables have correct policies

## 7. Edge Functions (Optional)
For server-side logic, create Edge Functions:
```bash
supabase functions new create-order
supabase functions new process-payment
```

## Cost Comparison: Firebase vs Supabase
| Feature | Firebase Free | Supabase Free |
|---------|--------------|---------------|
| Database | 1 GB | 500 MB |
| Storage | 5 GB | 1 GB |
| Bandwidth | 10 GB/month | 2 GB/month |
| Auth Users | 10,000/month | 50,000/month |
| Real-time | Limited | 200 concurrent |
| Price after free | $0.026/GB | $0.025/GB |

## Scaling to 1 Million Users
When you exceed free tier:
1. Upgrade to Pro ($25/month)
2. Or use Cloudinary for images (25 GB free)
3. Use CDN for static assets
4. Implement caching aggressively
