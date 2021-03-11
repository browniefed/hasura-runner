# Hasura CLI Runner

## Inputs

```yaml
PATH_TO_HASURA_PROJECT_ROOT:
  required: false
  description: The relative path from the root of your repo to where the Hasura project (containing config.yaml and your migrations/metadata folders) is located. For example, if your top-level directory contains a "hasura" folder, then this value should be ./hasura
HASURA_CLI_VERSION:
  required: false
  description: Version of Hasura CLI to download and use. Defaults to 'latest' if not set.
HASURA_ENDPOINT:
  required: false
  description: Optional overriding URL for the Hasura endpoint to call migrate apply and/or regression tests on. Will default to config.yaml value (as the CLI is run from the directory containing config.yaml).
HASURA_ADMIN_SECRET:
  required: false
  description: Optional overriding admin secret for the Hasura instance. Will default to config.yaml value (as the CLI is run from the directory containing config.yaml).
```

## Example for Hasura 2+

```
name: Production Deploy
on:
  push:
    branches:
      - master
jobs:
  hasura_migration:
    name: Hasura migration and Deploy
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repo
        uses: actions/checkout@v2

      - name: Hasura CI/CD
        uses: browniefed/hasura-runner@master
        with:
          args: metadata apply
        env:
          PATH_TO_HASURA_PROJECT_ROOT: ./hasura
          HASURA_CLI_VERSION: v2.0.0-alpha.4
          HASURA_ENDPOINT: ${{ secrets.HASURA_ENDPOINT }}
          HASURA_ADMIN_SECRET: ${{ secrets.HASURA_ADMIN_SECRET }}

      - name: Hasura CI/CD
        uses: browniefed/hasura-runner@master
        with:
          args: migrate apply --database-name default
        env:
          PATH_TO_HASURA_PROJECT_ROOT: ./hasura
          HASURA_CLI_VERSION: v2.0.0-alpha.4
          HASURA_ENDPOINT: ${{ secrets.HASURA_ENDPOINT }}
          HASURA_ADMIN_SECRET: ${{ secrets.HASURA_ADMIN_SECRET }}

      - name: Hasura CI/CD
        uses: browniefed/hasura-runner@master
        with:
          args: metadata reload
        env:
          PATH_TO_HASURA_PROJECT_ROOT: ./hasura
          HASURA_CLI_VERSION: v2.0.0-alpha.4
          HASURA_ENDPOINT: ${{ secrets.HASURA_ENDPOINT }}
          HASURA_ADMIN_SECRET: ${{ secrets.HASURA_ADMIN_SECRET }}

```

## Example Usage for v1.3.3

```yaml
name: Hasura CI/CD

on:
  push:
    branches:
      - develop

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Hasura CI/CD
        uses: browniefed/hasura-runner@master
        with:
          args: migrate apply
        env:
          PATH_TO_HASURA_PROJECT_ROOT: ./hasura
          HASURA_CLI_VERSION: v2.0.0-alpha.2
          HASURA_ENDPOINT: https://my-url.hasura.app
          HASURA_ADMIN_SECRET: ${{ secrets.HASURA_ADMIN_SECRET }}
```
