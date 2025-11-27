---
title: WhatsApp Webhook Cloudflare Tunnel Routing Issue
aliases: [WhatsApp Webhook Cloudflare Tunnel Routing Issue]
created: 2025-11-26 10:47
modified: 2025-11-26 10:52
tags: [cloudflare, troubleshooting, tunnel]
---

# WhatsApp Webhook Cloudflare Tunnel Routing Issue
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

### Issue #1: Catch-all route at the top

**Problem**: The `*` catch-all was intercepting all requests.

**Fix**: Reorder routes so specific paths come before the catch-all.

### Issue #2: Frontend API requests failing

After fixing the route order, a new issue emerged: the frontend dashboard was showing errors because it makes API calls to `/api/apps`, but there was no route for `/api/*`.

**How the frontend works**:
- Frontend API client defaults to `/api` prefix (see `frontend/src/services/api.ts:3`)
- Nginx is configured to proxy `/api/*` requests to backend at `http://webhook:3000/` (stripping the `/api` prefix)
- Example: `/api/apps` → nginx proxies to → `http://webhook:3000/apps`

**The problem**: Cloudflare routes had no `/api/*` entry, so those requests weren't reaching nginx.

**Final working route configuration**:

```
1. /api/* → http://frontend:80  (nginx will proxy to backend)
2. webhook/* → http://webhook:3000  (direct to backend for Meta webhooks)
3. health → http://webhook:3000
4. * → http://frontend:80  (catch-all for frontend SPA)
```

Note: The `apps*` route was removed because the frontend uses `/api/apps`, not `/apps` directly.
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
- `/api/*` → Frontend nginx → proxies to Backend API
- `/webhook/*` → Backend API (direct for Meta webhooks)
- `/health` → Backend API
## Key Learnings
1. **Route Order Matters**: In reverse proxy configurations (nginx, Cloudflare tunnel, etc.), always put specific routes before generic ones
2. **Same Domain for URL Generation**: When frontend generates URLs dynamically based on `window.location`, frontend and backend must share the same domain
3. **Path-Based Routing**: Use path prefixes (`/api/*`, `/webhook/*`) to separate services on the same domain
4. **Debugging**: Check which service is actually handling requests by examining container logs
5. **Cloudflare Tunnel**: Configuration is managed in Cloudflare dashboard, not in docker-compose or .env
6. **Layered Proxying**: It's valid to route through multiple proxies (Cloudflare → nginx → backend). In this setup, `/api/*` goes to nginx first, which then proxies to the backend
7. **Frontend API Defaults**: Check the frontend code for API URL defaults - `frontend/src/services/api.ts:3` uses `/api` as fallback when `VITE_API_URL` is not set
## Verification
After configuring all routes correctly:
```bash
# Backend health check - should return 200 OK
curl https://whatsapp.rspelitainsani.com/health

# Frontend should load
curl https://whatsapp.rspelitainsani.com/

# Frontend API calls - should return JSON
curl https://whatsapp.rspelitainsani.com/api/apps

# Meta webhook verification should work
curl "https://whatsapp.rspelitainsani.com/webhook/APP_ID?hub.mode=subscribe&hub.verify_token=TOKEN&hub.challenge=test"

# Check nginx is proxying correctly (from inside server)
ssh 1.19 "docker compose -f ~/whatsapp-webhook/docker-compose.yml logs frontend --tail 50"
```
## Related Files
- `docker-compose.yml` - Service orchestration
- `frontend/src/components/AppList.tsx:25` - Webhook URL generation
- `frontend/src/services/api.ts:3` - Frontend API client with `/api` default prefix
- `Dockerfile.frontend` → nginx config - `/api/*` proxy rules (inside container at `/etc/nginx/conf.d/default.conf`)
- `.env` - Environment configuration
- Cloudflare Dashboard → Tunnel → Public Hostname Routes
## References
- Project: `~/Projects/whatsapp-webhook`
- Production: `1.19:~/whatsapp-webhook`
- Domain: `whatsapp.rspelitainsani.com`