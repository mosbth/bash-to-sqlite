CREATE TABLE IF NOT EXISTS Port (
    id INTEGER PRIMARY KEY,
    server TEXT,
    port INTEGER,
    owner TEXT,
    created TEXT,
    updated TEXT,
    deleted TEXT
);

-- for port in {8000..8200}; do sqlite3 port.sqlite "INSERT INTO Port (server, port) VALUES (\"nodejs1.student.bth.se\", $port);"; done

-- sqlite3 port.sqlite "SELECT server, port FROM Port WHERE owner=\"mos\";"
-- sqlite3 --column port.sqlite "SELECT * FROM Port;"

-- sqlite3 port.sqlite "SELECT server, port FROM Port WHERE owner IS NULL ORDER BY port;"

-- sqlite3 port.sqlite "SELECT MIN(port) FROM Port WHERE owner IS NULL;"
-- sqlite3 port.sqlite "SELECT id FROM Port WHERE owner IS NULL ORDER BY port LIMIT 1;"
-- sqlite3 port.sqlite "SELECT id FROM Port WHERE port IN ((SELECT MIN(port) FROM Port WHERE owner IS NULL));"

-- sqlite3 port.sqlite "INSERT INTO Port (server, port) VALUES (\"nodejs1.student.bth.se\", $port);"

-- sqlite3 port.sqlite "UPDATE Port SET owner = \"mos\" WHERE id = 1;"
