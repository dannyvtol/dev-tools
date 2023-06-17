# DEnv Docker Environment
DEnv is a Docker-based environment created to run multiple projects an no more the port-bound issue.
DEnv is simply a Shell script with a Docker Compose file.

## Commands
The Shell script accepts four differen command:
| Command | Description
|---------|-----------------------------------------------|
| start   | Starts the Docker services                    |
| stop    | Stops the Docker services                     |
| destroy | Destroys the Docker services and it's volumes |
| help    | Shows the list op commands                    |

## Services
DEnv provides three handy services. Traefik Reverse Proxy, Portainer and MailHog. The services are accasible through the browser on the following urls:

| Service   | Url
|-----------|--------------------------|
| Traefik   | traefik.denv.localhost   |
| Portainer | portainer.denv.localhost |
| MailHog   | mailhog.denv.localhost   |

### Add a service to Traefik
Before your container is exposed by Traefik, you should configure it. The configuration is fairly easy to setup.

Open the docker-compose.yml of your own project (not from DEnv). Add the following to expose the service to Traefik.
Don't forget to replace the [name] with some name

```yaml
services:
  some_service:
    ports:
      # ... Other specified ports
      - '80' # Binds a random port of the host to this service's port 80
    networks:
      # ... Other specified networks
      - denv_proxy
    labels:
      # ... Other specified labels
      - traefik.http.routers.[name].rule=Host(`[name].localhost`)

networks:
  # ... Other specified networks
  denv_proxy:
    external: true
```

This will register the service to Traefik and expose it.

#### Require HTTPS?
The DEnv Shell script will generate a localhost.crt and localhost.key foy Traefik to use. Just add two other labels:

```yaml
services:
  some_service:
    labels:
      # ... Other specified labels
      - traefik.http.routers.[name].tls=true
      - traefik.http.routers.[name].entryPoints=https
      - traefik.http.routers.[name].rule=Host(`[name].localhost`)
```

For more information go to the [Traefik documentation](https://doc.traefik.io/traefik/)