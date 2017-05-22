
CREATE TABLE t_user (
    identity     NUMBER PRIMARY KEY ON CONFLICT REPLACE,
    username     TEXT,
    avatar       TEXT,
    phone_number TEXT,
    birthday     TEXT,
    email        TEXT,
    gender       TEXT,
    created_at   TEXT
);

CREATE TABLE t_address (
    uid          TEXT PRIMARY KEY ON CONFLICT REPLACE,
    name         TEXT,
    adcode       TEXT,
    district     TEXT,
    address      TEXT,
    latitude     NUMBER,
    longitude    NUMBER,
    [time]       TIMESTAMP NOT NULL DEFAULT (datetime('now'))
);
