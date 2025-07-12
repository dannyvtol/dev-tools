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

### HTTPS Support
A situation may arise in which a service requires an HTTPS connection to work (I.E. using a third-party sign-in). To keep this project as simple as it can be, HTTPS will not be supported out-of-the-box. An example will be provided instead.

#### Example
This example provides a set amount of files which can be copied to the locally cloned repository.

```yml
# docker-compose.override.yml

services:
  traefik:
    command:
      - --api.insecure=true
      - --providers.docker
      - --providers.docker.exposedByDefault=false
      - --providers.file.directory=/etc/traefik/dynamic
      - --ping=true
      - --entryPoints.http.address=:80
      - --entryPoints.https.address=:443
    ports:
      - '443:443'
    volumes:
      - ./certificates-traefik.yml:/etc/traefik/dynamic/certificates-traefik.yml
      - ./certificates:/certificates
    labels:
      - traefik.http.routers.traefik-https.entryPoints=https
      - traefik.http.routers.traefik-https.rule=Host(`traefik.localhost`)
      - traefik.http.routers.traefik-https.service=traefik
      - traefik.http.routers.traefik-https.tls=true
```

```yml
# certificates-traefik.yml

# tls:
#   certificates:
#     - certFile: /certificates/certificate.pem
#       keyFile: /certificates/certificate-key.pem
```

To generate certificates, [mkcert](https://github.com/FiloSottile/mkcert) can be used as a drop-in solution. For usage read the official documentation


### HTTPS Support

In certain scenarios, such as integrating third-party sign-in services, an HTTPS connection may be required. To maintain simplicity, HTTPS is not supported by default in this project. However, an example setup is provided for reference.

#### Example Setup

The following example includes a set of configuration files that can be added to your local project to enable HTTPS support using Traefik.

```yml
# docker-compose.override.yml

services:
  traefik:
    command:
      - --api.insecure=true
      - --providers.docker
      - --providers.docker.exposedByDefault=false
      - --providers.file.directory=/etc/traefik/dynamic
      - --ping=true
      - --entryPoints.http.address=:80
      - --entryPoints.https.address=:443
    ports:
      - "443:443"
    volumes:
      - ./certificates-traefik.yml:/etc/traefik/dynamic/certificates-traefik.yml
      - ./certificates:/certificates
    labels:
      - traefik.http.routers.traefik-https.entryPoints=https
      - traefik.http.routers.traefik-https.rule=Host(`traefik.localhost`)
      - traefik.http.routers.traefik-https.service=traefik
      - traefik.http.routers.traefik-https.tls=true
```

```yml
# certificates-traefik.yml

# tls:
#   certificates:
#     - certFile: /certificates/certificate.pem
#       keyFile: /certificates/certificate-key.pem
```

To generate local certificates, you can use [mkcert](https://github.com/FiloSottile/mkcert), a simple tool designed for creating locally trusted development certificates. For setup and usage, refer to the [official mkcert documentation](https://github.com/FiloSottile/mkcert).