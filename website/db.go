import "database/sql"
import _ "go-sql-driver/mysql"

// Configure the database connection (always check errors)
db, err := sql.Open("mysql", "username:password@(127.0.0.1:3306)/dbname?parseTime=true")

// Initialize the first connection to the database, to see if everything works correctly.
// Make sure to check the error.
err := db.Ping()

query := `
    CREATE TABLE users (
        id INT AUTO_INCREMENT,
        date TEXT NOT NULL,
		workout TEXT NOT NULL,
        weight TEXT NOT NULL,
        repitiions DATETIME,
        PRIMARY KEY (id)
    );`

// Executes the SQL query in our database. Check err to ensure there was no error.
_, err := db.Exec(query)

CREATE TABLE "accounts" (
    "id" bigserial PRIMARY KEY,
    "owner" varchar NOT NULL,
    "balance" bigint NOT NULL,
    "currency" varchar NOT NULL,
    "created_at" timestamptz NOT NULL DEFAULT (now())
  );
  
  CREATE TABLE "entries" (
    "id" bigserial PRIMARY KEY,
    "account_id" bigint NOT NULL,
    "amount" bigint NOT NULL,
    "created_at" timestamptz NOT NULL DEFAULT (now())
  );
  
  CREATE TABLE "transfers" (
    "id" bigserial PRIMARY KEY,
    "from_account_id" bigint NOT NULL,
    "to_account_id" bigint NOT NULL,
    "amount" bigint NOT NULL,
    "created_at" timestamptz NOT NULL DEFAULT (now())
  );
  
  ALTER TABLE "entries" ADD FOREIGN KEY ("account_id") REFERENCES "accounts" ("id");
  ALTER TABLE "transfers" ADD FOREIGN KEY ("from_account_id") REFERENCES "accounts" ("id");
  ALTER TABLE "transfers" ADD FOREIGN KEY ("to_account_id") REFERENCES "accounts" ("id");
  CREATE INDEX ON "accounts" ("owner");
  CREATE INDEX ON "entries" ("account_id");
  CREATE INDEX ON "transfers" ("from_account_id");
  CREATE INDEX ON "transfers" ("to_account_id");
  CREATE INDEX ON "transfers" ("from_account_id", "to_account_id");
  COMMENT ON COLUMN "entries"."amount" IS 'can be negative or positive';
  COMMENT ON COLUMN "transfers"."amount" IS 'must be positive';
