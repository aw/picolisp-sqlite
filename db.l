# SQLite DB interface

#
# VARIABLES
#

(setq
  *SQLITE_QUERY_TABLE (if (sys "SQLITE_QUERY_TABLE")  @ "table.l")
  *SQLITE_PATH        (if (sys "SQLITE_PATH")         @ "/usr/bin/sqlite3")
  *SQLITE_ERR         (if (sys "SQLITE_ERR")          @ "/dev/null")
  *SQLITE_INIT        (if (sys "SQLITE_INIT")         @ "init.sql")
  *SQLITE_DATABASE    (if (sys "SQLITE_DATABASE")     @ "database.db")
  )

#
# PUBLIC
#

# Usage: (sql QUERY [KEY-VALUE PAIRS])
#
#  Examples:
#   (sql 'array-usernames)                      # returns: ("alice" "bob" "charlie")
#   (sql 'object-user-info '((User_id "1")))    # returns: (("bob" "2" "22") ("charlie" "3" "23"))
#   (sql 'single-user-id '((Username "alice"))) # returns: "1"
#   (sql 'generic-users '((Order "RANDOM()")))  # returns (randomly): ("bob" "2")

[de sql (Function Params)
  (let Rule (assoc Function db-query-table)
    (bind Params
      (db-result (chop-sql (car Rule)) (eval (caddr Rule) ]

#
# PRIVATE
#

(load *SQLITE_QUERY_TABLE)

(de db-parse-row (Row)
  (mapcar pack (split (chop Row) "|")) )

[de chop-sql (Name)
  (pack (car (split (chop Name) "-") ]

[de db-init @
  (list *SQLITE_PATH
         "-init"
        *SQLITE_INIT
        *SQLITE_DATABASE
        (rest) ]

[de db-result (Type Query)
  (err *SQLITE_ERR
    (in (db-init Query)
      (cond
        [(= Type 'single) (pack (till "^J") ]
        [(= Type 'array)  (make (until (eof) (link (line T) ]
        [(= Type 'object) (make (until (eof) (link (db-parse-row (line T) ]
        (T                (db-parse-row (pack (till "^J") ]
