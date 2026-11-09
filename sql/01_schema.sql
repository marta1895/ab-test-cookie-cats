CREATE TABLE public.players (
	userid int4 NOT NULL,
	"version" text NOT NULL,
	sum_gamerounds int4 NOT NULL,
	retention_1 bool NOT NULL,
	retention_7 bool NOT NULL,
	CONSTRAINT players_pkey PRIMARY KEY (userid),
	CONSTRAINT players_version_check CHECK ((version = ANY (ARRAY['gate_30'::text, 'gate_40'::text])))
);