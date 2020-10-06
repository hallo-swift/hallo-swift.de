generate:
	hugo
	feedgen

ping:
	curl 'https://overcast.fm/ping?urlprefix=https:%2F%2Fhallo-swift.de'

.PHONY: generate ping

.DEFAULT_GOAL: generate
