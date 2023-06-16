# picolisp-sqlite - https://github.com/aw/picolisp-sqlite
#
# Makefile for unit and integration tests

PIL_MODULE_DIR ?= .modules
REPO_PREFIX ?= https://github.com/aw

# Unit testing
TEST_REPO = $(REPO_PREFIX)/picolisp-unit.git
TEST_DIR = $(PIL_MODULE_DIR)/picolisp-unit/HEAD
TEST_REF = v3.1.0

# Generic
.PHONY: check run-tests clean import test

$(TEST_DIR):
		mkdir -p $(TEST_DIR) && \
		git clone $(TEST_REPO) $(TEST_DIR) && \
		cd $(TEST_DIR) && \
		git checkout $(TEST_REF)

check: $(TEST_DIR) run-tests

run-tests: test.db test

test.db:
		sqlite3 -init test.db.schema test.db ".quit"

test:
		SQLITE_QUERY_TABLE=test-table.l SQLITE_DATABASE=test.db ./test.l

clean:
		rm -rf $(TEST_DIR) test.db
