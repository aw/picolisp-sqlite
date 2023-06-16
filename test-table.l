# DB query table
#
# Example list of SQL queries executed by (sql)

[de db-query-table
  (array-usernames        "The list of usernames in the database, sorted alphabetically from A to Z"
                          "SELECT username FROM users ORDER BY username ASC" )

  (single-user-id         "The user id of a specific user given the 'Username'"
                          (pack "SELECT user_id FROM users WHERE username='" Username "'") )

  (object-user-info       "The user details of the users whose id is greater than 'User_id'"
                          (pack "SELECT * FROM users WHERE user_id > '" User_id "'") )

  (generic-users          "The username and user id of the first row ordered by 'Order'"
                          (pack "SELECT username, user_id FROM users ORDER BY " Order) )
  ]
