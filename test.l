#!/usr/bin/env pil

(load (pack (car (file)) ".modules/picolisp-unit/HEAD/unit.l"))

(load (pack (car (file)) "db.l"))

[execute
  (assert-equal '("alice" "bob" "charlie") (sql 'array-usernames) "Should return the list of usernames")
  (assert-equal '(("bob" "2" "22") ("charlie" "3" "23")) (sql 'object-user-info '((User_id "1"))) "Should return users with ID greater than 1")
  (assert-equal "1" (sql 'single-user-id '((Username "alice"))) "Should return the user ID of alice")
  (assert-t (lst? (sql 'generic-users '((Order "RANDOM()")))) "Should return a row with one random user")
	]

(report)
