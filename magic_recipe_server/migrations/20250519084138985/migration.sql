BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "recipe" (
    "id" bigserial PRIMARY KEY,
    "author" text NOT NULL,
    "text" text NOT NULL,
    "date" timestamp without time zone NOT NULL,
    "ingredients" text NOT NULL
);


--
-- MIGRATION VERSION FOR magic_recipe
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('magic_recipe', '20250519084138985', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250519084138985', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
