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

## 2026-10-22 07:48

Added Step 1 screenshots and wrote the README with proof of the app running

## 2026-10-22 09:32

Step 2: pinned base images, non-root users and .dockerignore files. Intermittent DNS failures during builds fixed by retrying

Command: `docker compose ps` (exit 0)

```text
NAME      IMAGE     COMMAND   SERVICE   CREATED   STATUS    PORTS
```

## 2026-10-22 09:39

Step 2 verified: all services running as non-root (vote and worker uid 10001, result uid 1000); final stage of vote built and served HTTP 200

Command: `docker compose ps` (exit 0)

```text
NAME                          IMAGE                       COMMAND                  SERVICE   CREATED             STATUS                    PORTS
example-voting-app-db-1       postgres:15-alpine          "docker-entrypoint.s…"   db        About an hour ago   Up 17 seconds (healthy)   5432/tcp
example-voting-app-redis-1    redis:alpine                "docker-entrypoint.s…"   redis     About an hour ago   Up 17 seconds (healthy)   6379/tcp
example-voting-app-result-1   example-voting-app-result   "nodemon --inspect=0…"   result    14 minutes ago      Up 11 seconds             127.0.0.1:9229->9229/tcp, 0.0.0.0:8081->80/tcp, [::]:8081->80/tcp
example-voting-app-vote-1     example-voting-app-vote     "python app.py"          vote      14 minutes ago      Up 11 seconds (healthy)   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp
example-voting-app-worker-1   example-voting-app-worker   "dotnet Worker.dll"      worker    14 minutes ago      Up 11 seconds             
```

## 2026-10-22 13:19

Added setup notes and troubleshooting table to the README

## 2026-10-23 09:14

Step 3 (local fallback): destroyed and recreated the kind cluster with Terraform; node Ready again. First apply was slow because the kindest/node image download kept failing with unexpected EOF; retrying the pull with a loop fixed it

Command: `kubectl get nodes --kubeconfig terraform/kubeconfig` (exit 0)

```text
NAME                     STATUS   ROLES           AGE    VERSION
capstone-control-plane   Ready    control-plane   112s   v1.37.0
```

## 2026-10-27 09:37

Step 4: added GitHub Actions pipeline (tests, build, Trivy, push to ghcr.io tagged with commit SHA). Decisions: ghcr.io registry, deploy via temporary kind cluster in CI (to be added with the Helm chart). Pinned trivy-action to the safe v0.35.0 commit.

## 2026-10-27 12:02

Step 4: first CI run - vote passed, result failed the Trivy gate (5 OS and 2 Node CRITICAL). Fixed result: apt-get upgrade, proxy-addr lockfile refresh, removed npm from final image. Worker still to fix.

## 2026-10-27 14:28

Step 4: worker failed the Trivy gate (6 OS and 1 NuGet CRITICAL on Debian 11). Fixed by switching to dotnet runtime 7.0-bookworm-slim pinned by digest, adding apt-get upgrade, and pinning System.Drawing.Common 5.0.3.

## 2026-10-28 14:22

Step 4: worker failed the Trivy gate (6 OS and 1 NuGet CRITICAL on Debian 11). Fixed by switching to dotnet runtime 7.0-bookworm-slim pinned by digest, adding apt-get upgrade, and pinning System.Drawing.Common 5.0.3.

## 2026-10-29 04:09

Step 5: rollback demo complete. Revision 3 (bad vote tag) failed with ImagePullBackOff while the old pod kept serving; helm rollback to revision 2 created revision 4. Screenshots saved in docs/images.

## 2026-10-29 04:17

Step 5: rollback demo complete. Revision 3 (bad vote tag) failed with ImagePullBackOff while the old pod kept serving; helm rollback to revision 2 run twice (revisions 4 and 5). Screenshots saved in docs/images and README history corrected.

## 2026-10-29 04:24

Step 4/5: added CI deploy job (temporary kind cluster, helm install with the pushed image tag, end-to-end smoke test: vote reaches Postgres via the worker).
