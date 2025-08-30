# Odoo 17 → 18 Community Edition Migration Guide (Docker)

This document outlines a **reliable, repeatable** procedure to migrate an Odoo CE instance from version 17 to 18 using Docker. It captures the **working strategy** refined through hands-on troubleshooting and is intended for future migrations.

***

## 1. Prerequisites

-  Docker Engine & Docker Compose installed  
-  Existing Odoo 17 instance running via Docker Compose  
-  Database backup and volume snapshot process in place  
-  Shell access to your Docker host  

***

## 2. Directory Layout

```
/your-project/
│
├── compose.yaml           # Docker Compose for web, db, upgrade
├── .env                   # Environment variables (POSTGRES_USER, POSTGRES_PASSWORD, PORT_443, CONFIG, ADDONS)
├── config/                # Odoo configuration files
├── addons/                # Custom addons directory
├── odoo-18-src/           # Cloned Odoo 18 source code
└── OpenUpgrade/           # Cloned OCA/OpenUpgrade scripts
```

***

## 3. Backup Existing Data

1. Stop services:  
   `docker compose down`  
2. Backup database volume:  
   `docker run --rm --volumes-from <project>_db_1 -v $(pwd):/backup ubuntu tar czf /backup/data_backup.tar.gz -C /var/lib/postgresql/data/pgdata .`  
3. Backup Odoo filestore volume:  
   `docker run --rm -v <project>_web/data -v $(pwd):/backup ubuntu tar czf /backup/web_backup.tar.gz -C /data .`  
4. Save Compose & env:  
   `cp compose.yaml .env backup/`

***

## 4. Clone Required Repositories

```bash
git clone --depth 1 --branch 18.0 https://github.com/odoo/odoo.git odoo-18-src
git clone --depth 1 --branch 18.0 https://github.com/OCA/OpenUpgrade.git OpenUpgrade
```

***

## 5. Create `Dockerfile.upgrade`

```dockerfile
# Dockerfile.upgrade
FROM odoo:18.0

USER root
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    python3-venv \
    build-essential \
    python3-dev \
    libldap2-dev \
    libsasl2-dev \
    libssl-dev \
 && rm -rf /var/lib/apt/lists/*

RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY ./odoo-18-src/requirements.txt /tmp/requirements.txt
RUN sed -i 's/psycopg2==/psycopg2-binary==/g' /tmp/requirements.txt
RUN /opt/venv/bin/pip install --no-cache-dir -r /tmp/requirements.txt
RUN /opt/venv/bin/pip install --no-cache-dir openupgradelib

USER odoo
```

***

## 6. Update `compose.yaml`

Add a temporary **upgrade** service; remove after migration.

```yaml
services:
  web:
    image: odoo:17.0
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
      - ./odoo-18-src:/mnt/odoo-src
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
      -d postgres
      --update=all
      --stop-after-init
      --load=base,web,openupgrade_framework

volumes:
  web
  

networks:
  common-proxy_default:
    external: true
  network:
    external: false
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

## 8. Run Migration

1. Ensure database is fresh Odoo 17 state (restore if needed).
2. Start only the DB:  
   `docker compose up -d db`  
3. Execute upgrade container:  
   `docker compose run --build --rm upgrade`  

The logs should show **loading of multiple modules** without errors, then a clean shutdown.

***

## 9. Post-Migration Cleanup

1. Stop containers:  
   `docker compose down`  
2. Remove—or comment out—the **upgrade** service and its Dockerfile.
3. Update `web` service to `image: odoo:18.0`.
4. Start Odoo 18:  
   `docker compose up -d`  

***

## 10. Verification

-  Log into Odoo 18 at `https://<your-host>:${PORT_443}`  
-  Confirm data, custom modules, and workflows function as expected.  

***

**This procedure captures the exact working strategy**—including virtualenv setup, dependency fixes, and OpenUpgrade execution—for reliable future migrations of Odoo CE from 17 to 18 in Docker environments.
