# lovable-dev
Simple image for running lovable app in dev mode.
This image is specifically built to temporally serve a Lovable application using dev-mode in a self-hosted Supabase environment.

## Docker Compose usage

The repository already includes this compose file in `docker-compose.yml`:

```yaml
services:
	node-dev:
		image: ghcr.io/aperezmad/lovable-dev:latest
		container_name: ${APP_PREFIX}-lovable-dev
		user: "0:0"
		volumes:
			- ${BASE_PATH:-/root/app-data}/${APP_PATH}/app:/home/node/app
			- node-modules:/home/node/app/node_modules
		command: sh -c "bun install && bun dev"
		stdin_open: true
		tty: true
		networks:
			traefik-net:
		environment:
			VITE_SUPABASE_URL: ${SUPABASE_API_URL}
			VITE_SUPABASE_PUBLISHABLE_KEY: ${SUPABASE_ANON_KEY}
			POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
			HOST: 0.0.0.0
		labels:
			- "traefik.enable=true"
			- "traefik.http.routers.${APP_PREFIX}.rule=Host(`${URL}`)"
			- "traefik.http.routers.${APP_PREFIX}.entrypoints=websecure"
			- "traefik.http.routers.${APP_PREFIX}.tls.certresolver=letsencrypt"
			- "traefik.http.services.${APP_PREFIX}.loadbalancer.server.port=8080"

networks:
	traefik-net:
		external: true
		name: traefik-net

volumes:
	node-modules:
```

## Environment variables (.env)

Example `.env`:

```env
# Prefix used in container name and Traefik router/service names.
# Keep it short, lowercase, and without spaces.
# Recommended pattern: [a-z0-9-]+ (example: lovable, myapp, app-01)
APP_PREFIX=lovable

# Base path where app data is mounted from host
BASE_PATH=/root/app-data

# App-specific directory under BASE_PATH
APP_PATH=my-app

# Public host used by Traefik rule
URL=my-app.example.com

# Supabase values exposed to Vite app
SUPABASE_API_URL=https://my-app-api.example.com
SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY

# Postgres password passed to container
POSTGRES_PASSWORD=YOUR_POSTGRES_PASSWORD
```

## Tools installed in the image

From `Dockerfile`, the image includes:

- Node.js 20 (base image: node:20-alpine)
- Bun
- pnpm (via Corepack)
- Supabase CLI
- git
- curl
- openssh-client
- tar
- bash
- unzip
- postgresql-client
