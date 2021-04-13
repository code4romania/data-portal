# data-portal

Data Portal - the open data community

## Deployment

1. Create `.*.env` files

   ```shell
   cp .ckan.env.dist .ckan.env
   cp .env.dist .env
   ```

2. Start the project

  ```shell
  docker-compose build && docker-compose up -d
  ```

### Local development

In order to start the project with a custom branch for `ckanext-dataportaltheme`:

1. Checkout the project from https://github.com/code4romania/ckanext-dataportaltheme/
   in the folder a level up (`..`) from this one.
2. Edit your `ckan.env` file and change `ENV=dev`
3. Edit your `.env` file and change `COMPOSE_FILE=docker-compose.yml:docker-compose.dev.yml`

## Attribution

The code is adapted from the [Keitaro Inc. Docker CKAN repository](https://github.com/keitaroinc/docker-ckan).
