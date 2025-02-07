USE mykeyspace;
CREATE INDEX ON users (lname);
SELECT * FROM users where lname = 'smith';
