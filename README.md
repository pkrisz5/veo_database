# veo_database

The purpose of this project is to showcase how to populate PostgreSQL server with some health related public data.

## Prerequisities

Certain services and resources need to be setup and be operational to take advantage of.

* a kubernetes cluster, which you can manage by running `kubectl` commands
* a postgresql database server, which is reachable from the kubernetes pods
* a Docker image capable of running `git` and `Rscript` commands (default image is `kooplex/k8plex-ei-rstudio-basic`)

## Configuration and setup

Data _proxy_ scripts are run periodically as a cronjob in a dedicated namespace. No persistent storage is required right now, the scripts are clonde from the git repository.

```bash
kubectl create namespace veo-populate-db
```

Edit `secret.yaml` file to include the credentials to access the database. Make sure values are `base64` encoded and trimmed. After properly editing the secrets run

```bash
kubectl apply -f secret.yaml
```

Fine tune timing and the commandset in the `cron.yaml` file and issue

```bash
kubectl apply -f cron.yaml
```

