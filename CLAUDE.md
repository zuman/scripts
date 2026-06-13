# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A collection of bash/compose recipes for bootstrapping a Linux (Ubuntu) host and running a fleet of self-hosted services behind a reverse proxy. There is **no build/lint/test pipeline** — everything is shell scripts, Docker Compose YAML, and config files. "Running" the code means executing scripts on a target host or running `docker compose up -d` inside a container directory.

## Architecture

### Two-stage host bootstrap

1. **`home/cloud.sh`** — root-only, runs once on a fresh cloud VM. Creates a new user, copies `.bashrc`/`.profile`/`authorized_keys` from the default cloud user (default `ubuntu`), grants passwordless sudo, removes the default user from sudo, then clones this repo into `~/workspace/scripts` and runs `./home/setup.sh` as the new user.
2. **`home/setup.sh`** — per-user. Copies the `scripts/` directory to `~/scripts` and `home/.profile` to `~/.profile`, makes `clean-history` executable, and rewrites `PS1` in `~/.bashrc`. After this, `~/scripts` is on `PATH` and `zsync`, `genpasswd`, `clean-history` are available as commands.

`home/packages.sh` is **not** run end-to-end — README treats it as a menu. Run only the sections you need (e.g. "Setup Docker", "Net tools") for the host you're configuring.

### `~/scripts/` runtime layout (post-setup, on the host)

`home/.profile` sources `log.sh` which defines `$log` (`~/scripts/scripts.log`) and an `adddate <tag>` filter. Convention: pipe script output through `adddate "<name>" >> $log`. `clean-history` runs on every login to dedupe shell history and strip lines containing `AWS_SECRET_ACCESS_KEY` (extend the `exclude` list in `scripts/clean-history` to redact more secrets).

### Container fleet

Every service under `containers/<name>/compose.yaml` follows the same pattern:

- Reads config from a sibling `.env` file (gitignored, never committed). README has the canonical variable list per service.
- Joins the **external** Docker network `common-proxy_default`, which is owned by a separate repo `zuman/common-proxy` and **must exist before** running `docker compose up -d`. Without it, compose-up fails. The reverse proxy in that sibling repo is what terminates TLS and routes by hostname; service compose files only expose ports needed for direct/admin access.
- Volumes are bind-mounted from host paths supplied via `.env` (`$DATA`, `$CONFIG`, `$ADDONS`, etc.) — the path layout is the operator's choice, not enforced here.

Two services break the pattern:
- **`nginx-proxy-manager`** does **not** join `common-proxy_default` — it's an alternative to the common-proxy stack and binds 80/443 directly.
- **Nextcloud** is run via `containers/nextcloud/nc-setup.sh` (not compose). It launches the AIO master container, copies `nextcloud-connect.sh` to `~/scripts`, and installs a cron entry that runs every 5 min to attach the AIO containers (`nextcloud-aio-apache`, `nextcloud-aio-mastercontainer`) to `common-proxy_default` once they appear. The cron job is the integration glue — without it, AIO won't be reachable through the reverse proxy.

### Odoo migration (`containers/odoo/odoo-migration.md`)

OpenUpgrade-based incremental migration (N → N+1). Adds a temporary `upgrade` service to `compose.yaml` built from `Dockerfile.upgrade`, runs `--update=all --stop-after-init` against a copy of the volumes, then swaps the `web` image tag. Source clones (`odoo-src/`, `OpenUpgrade/`) are bind-mounted into the upgrade container. **`psycopg2` must be patched to `psycopg2-binary`** in `requirements.txt` before `pip install` (the Dockerfile.upgrade does this with `sed`).

### `zsync` — directory sync via rsync

`scripts/zsync [pull|push] <ssh-host-alias> <subdir>` syncs `~/zsync/<subdir>/` to/from `<alias>:~/zsync/<subdir>/`. Requires `<ssh-host-alias>` to be defined in `~/.ssh/config` (not a hostname). Honors `~/scripts/.zsyncignore`. Uses `--delete-excluded`, so anything matching `.zsyncignore` on the destination is **deleted** on each run — be deliberate when adding patterns.

### `vm/Dockerfile` — disposable Ubuntu sandbox

Builds a 22.04 image with a non-root sudoer. Username/password come from `--build-arg`. Run with `-v .:/home --network host` so `/home` (and therefore the user's home directory inside the container) is bind-mounted to the host's CWD — state survives container removal because it lives on the host.

## Conventions

- **`.env` files are required and gitignored** — the YAML files reference vars like `$PORT_443`, `$DATA`, `$POSTGRES_PASSWORD` directly. Always check the README section for the service before bringing it up; missing vars cause silent expansion to empty strings.
- Reverse-proxied services attach to `common-proxy_default` (external). New services should follow the same convention unless they're meant to bypass the proxy.
- Don't commit secrets to `gitlab.rb`, `odoo.conf`, etc. — these get copied into volumes by the operator after first boot, not baked into the repo.
- When adding scripts intended to run on the host, drop them in `scripts/` so they land in `~/scripts/` (on `PATH`) after `home/setup.sh`. Source `log.sh` and use `adddate` for consistent log lines.
