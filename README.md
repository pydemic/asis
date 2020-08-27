# ASIS

![Test badge](https://github.com/pydemic/asis/workflows/Test/badge.svg)
[![Coverage status](https://coveralls.io/repos/github/pydemic/asis/badge.svg?branch=main)](https://coveralls.io/github/pydemic/asis?branch=main)

## Development using docker

If you are using VSCode and remote-containers extension, you are ready to go. Simply reopen in container.

If not, you can use the `.misc/docker/dev/docker-compose.yml` file:

```bash
docker-compose -f .misc/docker/dev/docker-compose.yml up -d
docker-compose -f .misc/docker/dev/docker-compose.yml exec asis bash
```

## Installing dependencies and preparing database

Use the following command:

```bash
mix setup
```

If you only want to update the dependencies, use:

```bash
mix update.deps
```

Additionally, to seed data, use:

```bash
# Seed everything
mix seed

# Seed synchronously (single thread)
mix seed sync

# Seed everything from a module
mix seed geo

# Seed an entity from a module
mix seed geo.world

# Seed multiple entities or modules
mix seed icd_10 geo.city registries

# Seed multiple entities or modules synchronously (single thread)
mix seed sync consolidations geo.country registries.birth_registry
```

## Start the development server

To start the server:

```bash
mix start
```

## Restart the development server

To drop the database, seed, and start the server, use:

```bash
mix reseed
mix start
```

Remember to stop the metabase container before performing any operation that drops the database:

```bash
docker-compose -f .misc/docker/dev/docker-compose.yml stop metabase
```
