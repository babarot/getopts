ZSPEC_URL  = https://raw.githubusercontent.com/b4b4r07/zspec/master/bin/zspec

.PHONY: test

test:
	@test -f $(PWD)/zspec || curl -L $(ZSPEC_URL) -o $(PWD)/zspec
	@test -x $(PWD)/zspec || chmod 755 $(PWD)/zspec
	@$(PWD)/zspec --verbose "$(PWD)/*_test.zsh"
