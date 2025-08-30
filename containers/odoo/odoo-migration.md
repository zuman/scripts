# Docker-Based Migration Guide for Odoo CE (Incremental Versions)

This guide provides a **repeatable strategy** to migrate an Odoo Community Edition instance from version **N** to **N+1** (e.g., 17→18, 18→19) in a Docker environment. It captures the working approach refined through hands-on experience and is suitable for future upgrades.

***

## 1. Prerequisites

- Docker Engine & Docker Compose  
- Existing Odoo N instance running via Docker Compose  
- Database and volume backup procedures  
- Shell access to Docker host  

***

## 2. Project Layout

```
/your-project/
│
├── compose.yaml           # Docker Compose for web, db, upgrade
├── .env                   # Environment variables (POSTGRES_USER, POSTGRES_PASSWORD, PORT, CONFIG, ADDONS)
├── config/                # Odoo configuration files
├── addons/                # Custom addons directory
├── odoo-src/              # Cloned Odoo source code for version N+1
└── OpenUpgrade/           # Cloned OCA/OpenUpgrade scripts for version N→N+1
```

***

## 3. Backup Existing Data

1. **Stop services**  
   `docker compose down`  
2. **Backup database volume**  
   `docker run --rm --volumes-from <project>_db_1 -v $(pwd):/backup ubuntu tar czf /backup/db_backup.tar.gz -C /var/lib/postgresql/data .`  
3. **Backup filestore volume**  
   `docker run --rm -v <project>_web/data -v $(pwd):/backup ubuntu tar czf /backup/web_backup.tar.gz -C /data .`  
4. **Save Compose & env**  
   `cp compose.yaml .env backup/`  

***

## 4. Clone Repositories

```bash
git clone --depth 1 --branch N+1.0 https://github.com/odoo/odoo.git odoo-src
git clone --depth 1 --branch N+1.0 https://github.com/OCA/OpenUpgrade.git OpenUpgrade
```

***

## 5. Create `Dockerfile.upgrade`

```dockerfile
# Dockerfile.upgrade
FROM odoo:N+1.0

USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-venv \
    build-essential \
    python3-dev \
    libldap2-dev \
    libsasl2-dev \
    libssl-dev \
 && rm -rf /var/lib/apt/lists/*

RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY ./odoo-src/requirements.txt /tmp/requirements.txt
RUN sed -i 's/psycopg2==/psycopg2-binary==/g' /tmp/requirements.txt
RUN /opt/venv/bin/pip install --no-cache-dir -r /tmp/requirements.txt
RUN /opt/venv/bin/pip install --no-cache-dir openupgradelib

USER odoo
```

***

## 6. Update `compose.yaml`

Add a temporary **upgrade** service; remove after migration:

```yaml
services:
  web:
    image: odoo:N.0
    # unchanged

  db:
    image: postgres:15
    # unchanged

  upgrade:
    build:
      context: .
      dockerfile: Dockerfile.upgrade
    env_file: [.env]
    depends_on: [db]
    volumes:
      - ./odoo-src:/mnt/odoo-src
      - ./OpenUpgrade:/mnt/openupgrade
      - ${ADDONS}:/mnt/extra-addons
      - ./migrate.conf:/etc/odoo/migrate.conf
    environment:
      HOST: db
      USER: ${POSTGRES_USER}
      PASSWORD: ${POSTGRES_PASSWORD}
    networks:
      - network
    command: >
      /mnt/odoo-src/odoo-bin
      -c /etc/odoo/migrate.conf
      -d ${POSTGRES_DB}
      --update=all
      --stop-after-init
      --load=base,web,openupgrade_framework
```

***

## 7. Create `migrate.conf`

```ini
[options]
admin_passwd = admin
db_host = db
db_port = 5432
db_user = ${POSTGRES_USER}
db_password = ${POSTGRES_PASSWORD}

addons_path = /mnt/odoo-src/addons,/mnt/extra-addons,/mnt/openupgrade
upgrade_path = /mnt/openupgrade/openupgrade_scripts/scripts

limit_memory_hard = 0
limit_memory_soft = 0
```

***

## 8. Execute Migration

1. **Restore** your Odoo N database if needed.  
2. **Start** database service:  
   `docker compose up -d db`  
3. **Run** upgrade service:  
   `docker compose run --build --rm upgrade`  

Successful migration logs will show **multiple modules** loading and a clean shutdown.

***

## 9. Cleanup & Launch

1. `docker compose down`  
2. **Remove** or comment out the `upgrade` service and `Dockerfile.upgrade`.  
3. Update `web` service to `image: odoo:N+1.0`.  
4. **Start** your upgraded instance:  
   `docker compose up -d`  

***

## 10. Verify

-  Access Odoo N+1 at `https://<host>:${PORT}`  
-  Confirm data integrity, custom modules, and workflows.

***

**This template** supports any incremental Odoo CE migration (N→N+1) using Docker and OpenUpgrade, ensuring a consistent process for future upgrades.
