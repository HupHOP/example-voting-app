# Progress log

## 2026-10-21 19:53

Forked dockersamples/example-voting-app to HupHOP/example-voting-app

## 2026-10-21 19:54

Created a GitHub personal access token (repo and workflow scopes) and cloned the fork

## 2026-10-21 19:54

Checked the remotes

Command: `git remote -v` (exit 0)

```text
origin	https://github.com/HupHOP/example-voting-app.git (fetch)
origin	https://github.com/HupHOP/example-voting-app.git (push)
```

## 2026-10-21 19:56

Added upstream remote and a .gitignore covering secrets and Terraform state

Command: `git remote -v` (exit 0)

```text
origin	https://github.com/HupHOP/example-voting-app.git (fetch)
origin	https://github.com/HupHOP/example-voting-app.git (push)
upstream	https://github.com/dockersamples/example-voting-app.git (fetch)
upstream	https://github.com/dockersamples/example-voting-app.git (push)
```

## 2026-10-21 20:31

Docker WSL integration working

Command: `docker --version` (exit 0)

```text
Docker version 29.5.2, build 79eb04c
```

## 2026-10-21 22:24

Hit DNS timeouts pulling base images on the first build; retried and all images built. Vote on :8080 and result on :8081 work, vote counted
