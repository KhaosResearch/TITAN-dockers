clean:
	@rm -rf build dist .eggs *.egg-info
	@find . -type d -name '.mypy_cache' -exec rm -rf {} +
	@find . -type d -name '__pycache__' -exec rm -rf {} +

black: clean
	@isort --profile black .
	@black .

lint:
	@mypy .

.PHONY: tests

tests:
	@python -m unittest discover -s . --quiet
