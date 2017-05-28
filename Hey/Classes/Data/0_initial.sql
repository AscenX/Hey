
CREATE TABLE t_users (
    identity            NUMBER PRIMARY KEY ON CONFLICT REPLACE,
    name                TEXT,
    avatar              TEXT
);

CREATE TABLE t_contacts (
    identity            NUMBER PRIMARY KEY ON CONFLICT REPLACE,
    name                TEXT,
    avatar              TEXT
);

CREATE TABLE t_chat_records (
    identity            NUMBER PRIMARY KEY ON CONFLICT REPLACE,
    type                TEXT,
    time                TEXT,
    from_user_id        NUMBER,
    to_user_id          NUMBER,
    content             TEXT,
    image_url           TEXT,
    image_scale         NUMBER
);

CREATE TABLE t_chat_sessions (
    identity            NUMBER PRIMARY KEY ON CONFLICT REPLACE,
    username            TEXT,
    session_name        TEXT,
    image_url           TEXT,
    last_sentence       TEXT,
    time                TEXT
);
