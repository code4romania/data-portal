# data-portal
Data Portal - the open data community

## Deployment

1. Create `.*env` files
   
   ```shell
   cp .ckan-env.dist ckan-env
   cp .env.dist env
   ```

2. Start the project
   
    ```shell
    docker-compose build && docker-compose up -d
    ```

### Local deployment

In order to start the project with a custom branch and username, use the command below:

```shell
docker-compose build --build-arg DATAPORTAL_GIT_USER="user_name" --build-arg DATAPORTAL_GIT_BRANCH="branch_name"
```


## Attribution

The code is adapted from the [Keitaro Inc. Docker CKAN repository](https://github.com/keitaroinc/docker-ckan). 
