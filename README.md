# Dev Tools

This repository offers a collection of simple and efficient scripts for setting up various development services using Docker containers. It emphasizes a minimalistic approach to streamline your development environment with low-level solutions.

## Installation

1. Clone this repository to your desired directory.
2. Either symlink the scripts from the `scripts` directory or add the `scripts` directory to your `PATH`.

You're now ready to start!

## Scripts

| Script    | Description                                     |
|-----------|-------------------------------------------------|
| `denv.sh` | Manage the Docker-based development environment |

## Docker Environment (DEnv)

DEnv is a Docker-based setup designed to support multiple projects simultaneously without encountering port conflicts. It combines a Shell script with a Docker Compose file.

### Available Commands

The `denv.sh` script supports the following commands:

| Command   | Description                                     |
|-----------|-------------------------------------------------|
| `start`   | Starts the Docker services                      |
| `stop`    | Stops the Docker services                       |
| `destroy` | Removes the Docker services and their volumes   |
| `help`    | Lists all available commands                    |

### Included Services

DEnv includes three essential services: Traefik Reverse Proxy, Portainer, and MailPit. These services are accessible via the following URLs:

| Service   | URL                          |
|-----------|------------------------------|
| Traefik   | `traefik.denv.localhost`     |
| Portainer | `portainer.denv.localhost`   |
| MailPit   | `mailpit.denv.localhost`     |

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

#### Enabling HTTPS

If your service requires HTTPS, DEnv will generate `localhost.crt` and `localhost.key` files for Traefik. Add the following labels to your service configuration:

```yaml
services:
  your_service:
    labels:
      # ... Other specified labels
      - traefik.http.routers.[name]-https.tls=true
      - traefik.http.routers.[name]-https.entryPoints=https
      - traefik.http.routers.[name]-https.rule=Host(`[name].localhost`)
      - traefik.http.routers.[name].service=[service]
      - traefik.http.routers.[name]-https.service=[service]
```

For a detailed example of setting up HTTPS, refer to the `docker-compose.yml` inside the `docker-dev` directory.

For further details, consult the [Traefik documentation](https://doc.traefik.io/traefik/).