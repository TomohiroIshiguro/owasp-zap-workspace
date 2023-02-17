help:
	cat Makefile

zap-weekly:
	# Web アプリの設定値を監査する
	# USAGE: make zap-weekly URL={対象とする Web アプリのURL}
	docker run --name owasp-zap -it --rm \
	  -v "$(shell pwd)/output":/zap/wrk \
	  -t owasp/zap2docker-weekly zap-baseline.py \
	  -t ${URL} \
	  -r zap-report.html
