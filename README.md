# 🚀 Můj Orchestrátor Portfolio Projektů s Docker Compose 🐳

Tento repozitář slouží jako **centralizovaný orchestrátor** pro mé osobní projekty pomocí **Docker Compose**. Poskytuje robustní a skvěle strukturované vývojové prostředí, které aktuálně zahrnuje:

* **PostgreSQL:** 🐘 Jedna centrální databázová instance, připravená hostovat více databází pro různé aplikace. Každá má své vyhrazené uživatele a kontrolovaná oprávnění pro maximální bezpečnost.
* **PgAdmin:** 📊 Uživatelsky přívětivé webové grafické rozhraní pro snadnou a efektivní správu vašich PostgreSQL databází.
* **n8n:** ⚡️ Výkonný nástroj pro automatizaci pracovních postupů, integrovaný a připravený rozproudit vaše automatizace a propojit služby.

Toto nastavení klade důraz na **modularitu**, **bezpečnost** a **snadné použití**, čímž vám dává pevný a elegantní základ pro prezentaci vašich projektů.

---

## ✨ Hlavní rysy architektury ✨

* **Centrální PostgreSQL:** Všechny služby se připojují k jedinému, efektivnímu kontejneru PostgreSQL.
* **Vyhrazená databáze a uživatel pro každou službu:** 🛡️ Každá aplikace (jako n8n a vaše budoucí projekty) získá svou vlastní, izolovanou databázi a dedikovaného uživatele PostgreSQL se specifickými oprávněními. Žádné nechtěné zásahy!
* **Modulární inicializace databáze:** 🧩 Databáze a uživatelé PostgreSQL jsou automaticky nastaveni při prvním spuštění díky samostatným `.sql` skriptům (`db-init/01_n8n_init.sql`, `db-init/02_pgadmin_init.sql`), které jsou již šikovně součástí tohoto repozitáře. Přidávání a změny jsou tak hračkou!
* **Explicitní pojmenování kontejnerů:** 🏷️ Kontejnery mají jasné, předdefinované názvy (**`postgres`**, **`pgadmin4`**, **`n8n`**), což zjednodušuje jejich identifikaci a správu pomocí příkazů `docker ps` a `docker logs`.
* **Sdílená Docker síť:** 🌐 Všechny služby bydlí na jediné, explicitně definované Docker síti s názvem **`shared_network`**, což zajišťuje bezproblémovou a rychlou komunikaci mezi nimi.
* **Perzistentní data:** 💾 Všechna data databáze a aplikace jsou uložena ve spolehlivých Docker svazcích, takže vaše konfigurace a pracovní postupy zůstanou zachovány i po restartu kontejnerů.

---

## 🚀 Jak začít – Krok za krokem 🚀

Pro spuštění PostgreSQL, n8n a PgAdmin na lokálním počítači postupujte takto:

1.  **Naklonujte tento repozitář:**
    ```bash
    git clone https://github.com/robinbezak-com/docker-compose.git
    cd docker-compose
    ```
    *💡 Všechny inicializační SQL soubory pro databázi už najdete připravené v adresáři `db-init/`.*

2.  **Vytvořte a nakonfigurujte soubor `.env`:**
    Tento soubor obsahuje citlivé informace, jako jsou hesla. **🔥 Důležité: Nikdy ho nesdílejte ani nesnávejte do Gitu! 🔥**
    Zkopírujte příklad souboru a vytvořte si vlastní `.env`:
    ```bash
    cp .env.example .env
    ```
    Nyní **otevřete nově vytvořený soubor `.env`** (např. `nano .env` nebo `code .env`) a **vyplňte silná, unikátní hesla a požadované přihlašovací údaje** pro všechny proměnné.

    **Ujistěte se, že:**
    * `N8N_DB_PASSWORD` ve vašem `.env` **přesně odpovídá** heslu použitému pro `n8n_user` definované v `db-init/01_n8n_init.sql`.
    * `PGADMIN_VIEWER_PASSWORD` ve vašem `.env` **přesně odpovídá** heslu použitému pro `pgadmin_user` definované v `db-init/02_pgadmin_init.sql`.

3.  **Spusťte všechny služby:**
    ```bash
    docker compose up -d
    ```
    Příznak `-d` spustí služby v odděleném režimu (na pozadí), takže můžete vesele pokračovat v práci na terminálu.

    * **Poznámky k prvnímu spuštění:** ⏳ Kontejner PostgreSQL bude chvíli inicializovat svůj datový adresář a spouštět skripty z `db-init/`. PgAdmin a n8n se mohou zpočátku tvářit, že se nemohou připojit, ale díky chytrému nastavení `depends_on` (s podmínkou `service_healthy`) budou vytrvale zkoušet a nakonec se úspěšně připojí. Trpělivost se vyplatí!

---

## 🌐 Přístup ke službám – Vaše brána k ovládání 🌐

Jakmile jsou služby spuštěny a běží, můžete k jejich uživatelským rozhraním přistupovat ve svém webovém prohlížeči:

* **Uživatelské rozhraní n8n:**
    👉 [http://localhost:5678](http://localhost:5678) (nebo port, který jste nakonfigurovali pro `N8N_PORT` ve vašem `.env`)
    * **Přihlášení:** Použijte `N8N_USER` a `N8N_PASSWORD`, které jste nastavili ve vašem souboru `.env`.
* **Uživatelské rozhraní PgAdmin:**
    👉 [http://localhost:8080](http://localhost:8080) (nebo port, který jste nakonfigurovali pro `PGADMIN_PORT` ve vašem `.env`)
    * **Přihlášení:** Použijte `PGADMIN_EMAIL` a `PGADMIN_PASSWORD`, které jste nastavili ve vašem souboru `.env`.

### 🔗 Připojení PgAdmin k vaší databázi PostgreSQL

Po prvním přihlášení do PgAdminu budete muset přidat připojení k serveru, abyste mohli spravovat vaše databáze:

1.  Klikněte na **"Add New Server"** v levém postranním panelu (nebo přejděte na `Servers` -> `Create` -> `Server`).
2.  V záložce **General:**
    * **Name:** `Můj Centrální Portfolio Databáze` (nebo jakýkoli popisný název, který se vám líbí)
3.  V záložce **Connection:**
    * **Host name/address:** `postgres_db` (toto je interní název služby z `docker-compose.yml` pro komunikaci v rámci Docker sítě)
    * **Port:** `5432`
    * **Maintenance database:** `postgres` (nebo `n8n_data`, nebo jakákoli jiná databáze, ke které má PgAdmin přístup)
    * **Username:** `pgadmin_user` (vyhrazený, ne-superuživatelský účet vytvořený v `db-init/02_pgadmin_init.sql`)
    * **Password:** `PGADMIN_VIEWER_PASSWORD`, které jste nastavili ve vašem souboru `.env`.
4.  Klikněte na **"Save"**. 🎉 Hotovo! Nyní byste měli být schopni procházet databáze `postgres` a `n8n_data` v rámci PgAdminu.

---

## 🏗️ Struktura databáze a uživatelé – Bezpečnost na prvním místě 🏗️

Vaše služba `postgres_db` funguje jako centrální server PostgreSQL, hostující více databází a uživatelů s jasnými hranicemi:

* **Databáze `n8n_data`:** Vyhrazená výhradně pro interní data n8n. Nic jiného se tam neplete.
* **Uživatel `n8n_user`:** Vyhrazený uživatel PostgreSQL s oprávněními pouze pro databázi `n8n_data`. Tím se zajistí, že n8n nemůže náhodně ani úmyslně ovlivnit data jiných databází.
* **Uživatel `pgadmin_user`:** Vyhrazený uživatel PostgreSQL pro PgAdmin pro připojení a prohlížení databází. Tento uživatel má pečlivě omezená oprávnění (`SELECT` a `CONNECT`), což je v souladu s nejlepšími bezpečnostními postupy.
* **Uživatel `postgres`:** Výchozí superuživatel instance PostgreSQL. Jeho heslo je nastaveno pomocí `POSTGRES_ROOT_PASSWORD` ve vašem `.env`. Tento uživatel je primárně určen pro počáteční administrativní úkoly a **neměl by být ideálně používán** přímo aplikacemi ani pro běžná připojení PgAdmin. Myslete na něj jako na nouzový klíč.

---

## 💡 Přidávání dalších projektů v budoucnu – Rozšiřujte s lehkostí 💡

Toto nastavení je navrženo pro snadné a elegantní rozšíření. Když budete vyvíjet nové aplikace pro své portfolio, stačí:

1.  **Přidat nový inicializační soubor SQL** do adresáře `db-init/` (např. `03_muj_projekt_init.sql`). V tomto souboru vytvořte vyhrazenou databázi a vyhrazeného uživatele pro vaši novou aplikaci, udělte pouze nezbytná oprávnění.
2.  **Přidat nový blok služby** pro vaši aplikaci do `docker-compose.yml`. Nakonfigurujte ho tak, aby používal Docker image vaší aplikace a připojoval se ke službě `postgres_db` pomocí svého specifického názvu databáze a uživatelského jména/hesla.
3.  **Aktualizujte svůj soubor `.env`** o heslo uživatele databáze nové aplikace.
4.  **Volitelně, aktualizujte `db-init/02_pgadmin_init.sql`** tak, aby zahrnoval `GRANT CONNECT ON DATABASE vase_nova_app_db TO pgadmin_user;` (a případně udělil více oprávnění `SELECT`), aby PgAdmin mohl také vidět a spravovat novou databázi. *(Pro plné uplatnění změn v existující databázi je někdy nutné provést `docker compose down -v` a `up -d` na první spuštění, nebo ruční úpravy přes `psql` pro již existující data.)*

---

## 🛑 Zastavení služeb – Klidně a čistě 🛑

Pro zastavení všech spuštěných služeb bez odstranění jejich perzistentních dat:
```bash
docker compose down
```

Pro zastavení všech služeb a odstranění jejich kontejnerů, sítí a všech přidružených svazků perzistentních dat (užitečné pro čistý start, ale buďte opatrní, protože odstraní všechny pracovní postupy n8n a data databáze):
```bash
docker compose down -v
```