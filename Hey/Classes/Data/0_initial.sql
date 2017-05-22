
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

CREATE TABLE t_chat_records (
    identity          NUMBER PRIMARY KEY ON CONFLICT REPLACE,
    user_id     NUMBER,
    text         TEXT,
    image_url   TEXT
);

CREATE TABLE t_chat_sessions (
    identity          NUMBER PRIMARY KEY ON CONFLICT REPLACE,
    user_ids    BLOB,
    username         TEXT,
    session_name       TEXT,
    image_url   TEXT,
    last_sentence TEXT,
    time TEXT
);
