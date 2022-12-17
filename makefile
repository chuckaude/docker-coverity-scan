TAG = coverity-scan
VERSION = 2022.9.2

maven: clean copy-maven build test-maven
net6: clean copy-net6 build test-net6

clean:
	docker rmi -f ${TAG}
	docker system prune -f
	rm -f cov-analysis-linux64-${VERSION}.sh license.dat

copy-maven:
	cp -fp Dockerfile.maven Dockerfile

copy-net6:
	cp -fp Dockerfile.net6 Dockerfile

build:
	ln /opt/coverity/software/cov-analysis-linux64-${VERSION}.sh .
	ln /opt/coverity/software/license.dat .
	docker build --build-arg VERSION=${VERSION} -t ${TAG} .
	docker system prune -f
	rm -f cov-analysis-linux64-${VERSION}.sh license.dat

test-maven:
	docker run --rm -e COV_URL=${COV_URL} -e COV_USER=${COV_USER} -e COVERITY_PASSPHRASE=${COVERITY_PASSPHRASE} \
		${TAG} https://github.com/WebGoat/WebGoat.git develop

test-net6:
	docker run --rm -e COV_URL=${COV_URL} -e COV_USER=${COV_USER} -e COVERITY_PASSPHRASE=${COVERITY_PASSPHRASE} \
		${TAG} https://github.com/tobyash86/WebGoat.NET.git WebgoatNet6.0
