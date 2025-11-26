# WhatsApp Webhook Cloudflare Tunnel Routing Issue

Date: 2025-11-26
Tags: #cloudflare #tunnel #routing #whatsapp #troubleshooting

## Problem Overview

WhatsApp webhook service was returning 404 on `https://whatsapp.rspelitainsani.com` but working fine on local IP `http://192.168.1.19:8087`.

Upon investigation, found that webhook POST requests from Meta/Facebook were getting **HTTP 405 (Method Not Allowed)** errors.

## Root Cause

The issue was caused by **incorrect route ordering** in Cloudflare Tunnel configuration.

### Architecture

The service uses Docker Compose with 4 containers:
- **postgres** - PostgreSQL database
- **webhook** (port 3000) - Backend API (Express.js)
- **frontend** (port 80) - Frontend dashboard (React + nginx)
- **cloudflared** - Cloudflare tunnel

All services share the same domain: `whatsapp.rspelitainsani.com`

### Why Same Domain?

The frontend generates webhook URLs dynamically using:
```typescript
const url = `${window.location.protocol}//${window.location.host}/webhook/${appId}`;
```

This means frontend and backend **must be on the same domain** for webhook URLs to work correctly. When user copies webhook URL from dashboard, it becomes:
- `https://whatsapp.rspelitainsani.com/webhook/1177829700968920`

Using different subdomains (e.g., `whatsapp-api.rspelitainsani.com`) would break this URL generation.

## The Issue

Initial Cloudflare tunnel route configuration:
```
1. * → http://frontend:80
2. apps* → http://webhook:3000
3. webhook/* → http://webhook:3000
4. health → http://webhook:3000
```

**Problem**: Cloudflare tunnel processes routes **top-to-bottom**, first match wins. The catch-all route (`*`) was first, so it captured ALL requests including `/webhook/*`, `/apps`, and `/health` - routing them to nginx (frontend) instead of the backend API.

Since nginx only serves static files and doesn't handle POST requests to `/webhook/*`, Meta's webhook requests returned **405 Method Not Allowed**.

### Logs Evidence
```
whatsapp-webhook-frontend | POST /webhook/1177829700968920 HTTP/1.1" 405
```

Requests were hitting nginx (frontend container), not the backend.

## Solution

**Reorder routes** so specific paths come before the catch-all:

```
1. webhook/* → http://webhook:3000
2. apps* → http://webhook:3000
3. health → http://webhook:3000
4. * → http://frontend:80  (catch-all must be LAST)
```

### How Cloudflare Tunnel Routing Works

- Routes are evaluated **sequentially from top to bottom**
- First matching route wins
- More specific routes must be listed before generic/catch-all routes
- The `*` catch-all should **always be last**

## Environment Configuration

After fixing routes, the `.env` file should use the same domain for both:

```bash
# Backend CORS configuration
FRONTEND_URL=https://whatsapp.rspelitainsani.com

# Frontend API endpoint
VITE_API_URL=https://whatsapp.rspelitainsani.com
```

Both values point to the same domain because path-based routing separates them:
- `/` → Frontend (React dashboard)
- `/webhook/*` → Backend API
- `/apps` → Backend API
- `/health` → Backend API

## Key Learnings

1. **Route Order Matters**: In reverse proxy configurations (nginx, Cloudflare tunnel, etc.), always put specific routes before generic ones
2. **Same Domain for URL Generation**: When frontend generates URLs dynamically based on `window.location`, frontend and backend must share the same domain
3. **Path-Based Routing**: Use path prefixes (`/api/*`, `/webhook/*`) to separate services on the same domain
4. **Debugging**: Check which service is actually handling requests by examining container logs
5. **Cloudflare Tunnel**: Configuration is managed in Cloudflare dashboard, not in docker-compose or .env

## Verification

After reordering routes:
```bash
# Should return 200 OK
curl https://whatsapp.rspelitainsani.com/health

# Frontend should load
curl https://whatsapp.rspelitainsani.com/

# Meta webhook verification should work
curl "https://whatsapp.rspelitainsani.com/webhook/APP_ID?hub.mode=subscribe&hub.verify_token=TOKEN&hub.challenge=test"
```

## Related Files

- `docker-compose.yml` - Service orchestration
- `frontend/src/components/AppList.tsx:25` - Webhook URL generation
- `.env` - Environment configuration
- Cloudflare Dashboard → Tunnel → Public Hostname Routes

## References

- Project: `~/Projects/whatsapp-webhook`
- Production: `1.19:~/whatsapp-webhook`
- Domain: `whatsapp.rspelitainsani.com`
