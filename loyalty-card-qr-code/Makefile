VENV ?= .venv
PYTHON ?= python3
VENV_PYTHON := $(VENV)/bin/python
GENERATE ?= $(VENV_PYTHON) qr_loyalty.py
OUT_DIR ?= out
CSV_FILE ?= cards.csv
TARGETS_MK := .targets.mk

-include $(TARGETS_MK)

.PHONY: all venv install clean

all: $(PNG_TARGETS)

venv:
	$(PYTHON) -m venv $(VENV)
	$(VENV_PYTHON) -m pip install -r requirements.txt

install: venv

$(TARGETS_MK): $(CSV_FILE)
	@awk -F, '\
		$$1 !~ /^[[:space:]]*#/ && NF >= 2 { \
			gsub(/^[[:space:]]+|[[:space:]]+$$/, "", $$1); \
			gsub(/^[[:space:]]+|[[:space:]]+$$/, "", $$2); \
			if ($$1 != "") { \
				print "PNG_TARGETS += $(OUT_DIR)/" $$1 ".png"; \
				print "$(OUT_DIR)/" $$1 ".png: " "$(CSV_FILE)" " | venv"; \
				print "\t$(GENERATE) --data " "\"" $$2 "\"" " --output " "\"" "$(OUT_DIR)/" $$1 ".png" "\""; \
				print ""; \
			} \
		}' $(CSV_FILE) > $@

all clean: $(TARGETS_MK)

clean:
	rm -f $(PNG_TARGETS) $(TARGETS_MK)
