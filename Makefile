generate:
	hugo
	feedgen

.PHONY: generate

.DEFAULT_GOAL: generate
