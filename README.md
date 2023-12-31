# SQLite 3 interface written in PicoLisp

This PicoLisp library acts as an interface to the command line [sqlite3](https://www.sqlite.org/index.html) binary program. It can be included in other PicoLisp programs and can be used to execute pre-defined SQL queries with optional parameters.

![picolisp-sqlite](https://github.com/aw/picolisp-sqlite/assets/153401/b35c2d77-a915-48dc-bfc1-4c8f3bd795b2)

  1. [Requirements](#requirements)
  2. [Getting started](#getting-started)
  3. [Usage](#usage)
  4. [Examples](#examples)
  5. [How it works](#how-it-works)
  6. [Testing](#testing)
  7. [Contributing](#contributing)
  8. [License](#license)

# Requirements

  * PicoLisp 64-bit `pil21`
  * SQLite3 binary

# Getting started

This library requires [PicoLisp](https://picolisp.com) and the **sqlite3** binary. On _Debian_ systems, they can be installed with:

```
apt-get install picolisp sqlite3
```

To ensure everything works on your system, run the tests first:

```
make check
```

# Usage

The library file to be loaded from PicoLisp programs is: `db.l`.

To start, the following default variables are defined:

| Variable | Default value | Description |
| ----: | :---- | :---- |
| **SQLITE_QUERY_TABLE** | `table.l` | File with list of pre-defined SQL queries |
| **SQLITE_PATH** | `/usr/bin/sqlite3` | Path of SQLite 3 binary program |
| **SQLITE_ERR**| `/dev/null` | Output location of SQL query errors |
| **SQLITE_INIT** | `init.sql` | File with list of initialization commands prior to executing SQL queries |
| **SQLITE_DATABASE** | `database.db` | SQLite 3.x database file |

The above variables can be overwritten on the command line, example:

```bash
export SQLITE_QUERY_TABLE=my-table.l
```

They can also be overwritten in PicoLisp **before** loading `db.l`, example:

```picolisp
: (sys "SQLITE_QUERY_TABLE" "my-table.l")
-> "my-table.l"
: (load "db.l")
-> db-result
```

# Examples

The following example is also used by the `Makefile` for testing the library with `test.l`.

## Build the database

This generates a test database using the test database schema file `test.db.schema`.

```bash
make test.db
```

## Set some variables

This exports the test query table and database file names to be used by `db.l`.

```bash
export SQLITE_QUERY_TABLE=test-table.l
export SQLITE_DATABASE=test.db
```

## Load the library in PicoLisp

This starts PicoLisp and loads `db.l`.

```bash
pil db.l
```

## Execute some queries

This executes four SQL queries defined in `test-table.l`.

```picolisp
# Example

: (sql 'array-usernames)
-> ("alice" "bob" "charlie")
: (sql 'object-user-info '((User_id "1")))
-> (("bob" "2" "22") ("charlie" "3" "23"))
: (sql 'single-user-id '((Username "alice")))
-> "1"
: (sql 'generic-users '((Order "RANDOM()")))
-> ("charlie" "3")
```

# How it works

All SQL commands must be executed by the public `(sql)` function. It takes 2 arguments: the query, and optional key-value pair arguments.

The query is a function name that is prefixed by either `single-`, `array-`, `object-`, or `somethingelse-`. This can be seen in the `(db-result)` code definition.

| Query type | Description | Example |
| :---- | :---- | :---- |
| `single-` | Returns a single value | `"1"` |
| `array-` | Returns a list of values | `("alice" "bob" "charlie")` |
| `object-` | Returns a list of lists | `(("bob" "2" "22") ("charlie" "3" "23"))` |
| `anything-` | Returns a single row | `("bob" "2")` |

All queries are fixed and defined in the `(db-query-table)` function of the `*SQLITE_QUERY_TABLE` variable (defaults to `table.l`). See `test-table.l` for an example.

The second argument of each query is a `string` which acts as a comment for your future self. The third argument is the actual SQL query, which can contain variables loaded from the environment (i.e: passed as key-value pair arguments).

Let's look at a simple example `table.l`:

```picolisp
[de db-query-table
  (single-user-id   "The user id of a specific user given the 'Username'"
                    (pack "SELECT user_id FROM users WHERE username='" Username "'") )
    ]
```

In the above example, the query type is `single`, and it accepts one argument `Username`. It would be called from PicoLisp like this:

```picolisp
(sql 'single-user-id '((Username "bob")))
```

In the above example, the only argument is the key-value pair `(Username "bob")` where `Username` in the `single-user-id` query will be substituted by the value `bob`, and the final SQL query will look like this:

```sql
SELECT user_id FROM users WHERE username='bob'
```

Of course, this will not prevent an SQL injection attack with the key-value pair `(Username "'; DROP TABLE users;'")`, so please use proper form and data validation prior to submitting values for the SQL query.

# Testing

This library includes a small suite of [unit tests](https://github.com/aw/picolisp-unit). To run the tests, type:

    make check

# Contributing

  * If you find any bugs or issues, please [create an issue](https://github.com/aw/picolisp-sqlite/issues/new).

# License

[MIT License](LICENSE)

(c) 2023 Alexander Williams, On-Prem, https://on-premises.com
