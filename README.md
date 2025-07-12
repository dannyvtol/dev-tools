# Dev Tools

This repository offers a collection of simple development services using Docker containers. It emphasizes a minimalistic approach to streamline your development environment with low-level solutions.

## Installation

1. Clone this repository to your desired directory.
2. Run `docker compose up -d` from within the repository directory
3. Great job! You're done

You're now ready to start!

## Docker Environment (DEnv)

DEnv is a Docker-based setup designed to support multiple projects simultaneously without encountering port conflicts. It combines a Shell script with a Docker Compose file.

### Included Services

DEnv includes three essential services: Traefik Reverse Proxy, Portainer, and MailPit. These services are accessible via the following URLs:

| Service   | URL                          |
|-----------|------------------------------|
| Traefik   | `traefik.localhost`          |
| Portainer | `portainer.localhost`        |
| MailPit   | `mailpit.localhost`          |

### Adding a Service to Traefik

To expose a service via Traefik, you’ll need to modify your project’s `docker-compose.yml` file (not the one from DEnv). Follow these steps:

1. Open your project’s `docker-compose.yml`.
2. Add the following configuration to expose your service through Traefik. Replace `[name]` with your desired service name:

```yaml
services:
  your_service:
    networks:
      # ... Other specified networks
      - denv_proxy
    labels:
      # Enable Traefik for this service
      - traefik.enable=true
      - traefik.http.routers.[name].entryPoints=http
      - traefik.http.routers.[name].rule=Host(`[name].localhost`)

      # Optional label if the container exposes a different port than 80
      - traefik.http.services.[name].loadbalancer.server.port=[port]

networks:
  # ... Other specified networks
  denv_proxy:
    external: true
```

This configuration will register and expose your service through Traefik.

For further details, consult the [Traefik documentation](https://doc.traefik.io/traefik/).