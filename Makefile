# SHAE Perl Log Analyzer — Makefile
# No compile step (Perl). Targets: test, install, clean.

PERL ?= perl
SRC := src/analyzer.pl
SAMPLE := /tmp/shae-access.log

.PHONY: all test install clean setup-sample

all:
	@echo "shae-log-analyzer: interpreted Perl, no build step required."

test: setup-sample
	@echo "== analyzer report =="
	$(PERL) $(SRC) $(SAMPLE)

setup-sample:
	@printf '203.0.113.5 - - [10/Oct/2023:13:05:12 +0000] "GET /index.html HTTP/1.1" 200 1234 "-" "Mozilla/5.0"\n' > $(SAMPLE)
	@printf '203.0.113.5 - - [10/Oct/2023:13:15:44 +0000] "GET /about.html HTTP/1.1" 200 890 "-" "Mozilla/5.0"\n' >> $(SAMPLE)
	@printf '198.51.100.23 - - [10/Oct/2023:14:02:01 +0000] "GET /index.html HTTP/1.1" 200 1234 "-" "curl/7.88"\n' >> $(SAMPLE)
	@printf '198.51.100.23 - - [10/Oct/2023:14:07:33 +0000] "POST /login HTTP/1.1" 302 0 "-" "curl/7.88"\n' >> $(SAMPLE)
	@printf '198.51.100.23 - - [10/Oct/2023:14:12:10 +0000] "GET /missing HTTP/1.1" 404 150 "-" "curl/7.88"\n' >> $(SAMPLE)
	@printf '198.51.100.23 - - [10/Oct/2023:15:00:00 +0000] "GET /index.html HTTP/1.1" 500 0 "-" "curl/7.88"\n' >> $(SAMPLE)
	@printf '203.0.113.5 - - [10/Oct/2023:15:05:00 +0000] "GET /api/v1/users HTTP/1.1" 200 4096 "-" "Mozilla/5.0"\n' >> $(SAMPLE)
	@printf '203.0.113.5 - - [10/Oct/2023:15:05:05 +0000] "GET /api/v1/users HTTP/1.1" 200 4096 "-" "Mozilla/5.0"\n' >> $(SAMPLE)
	@printf 'bad line that should be ignored\n' >> $(SAMPLE)

install:
	bash scripts/install.sh

clean:
	@rm -f $(SAMPLE)
