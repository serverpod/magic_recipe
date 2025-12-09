BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "recipe" ADD COLUMN "imagePath" text;

--
-- MIGRATION VERSION FOR magic_recipe
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('magic_recipe', '20251208122304304', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208122304304', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20250825102336032-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250825102336032-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20251204015642995', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251204015642995', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20251128113842674', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251128113842674', "timestamp" = now();


COMMIT;
