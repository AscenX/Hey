
CREATE TABLE t_users (
    identity     NUMBER PRIMARY KEY ON CONFLICT REPLACE,
    name     TEXT,
    avatar       TEXT
);

CREATE TABLE t_contacts (
    identity          NUMBER PRIMARY KEY ON CONFLICT REPLACE,
    name         TEXT,
    avatar       TEXT
);
