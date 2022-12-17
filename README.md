# Dockerized Coverity Scans

Examples for bundling the Coverity analysis toolkit into a base image and using an entrypoint.sh to automatically scan the specified repo/branch.

**Instructions**
1. Copy one of the example Dockerfiles and entrypoint.sh
2. Optionally change FROM in Dockerfile to meet your needs
3. Copy your Coverity license and analysis installer
4. Build the image via
```
docker build --build-arg VERSION=2022.9.2 -t coverity-scan .
```
5. Scan a repo via
```
docker run --rm -e COV_URL=YOUR_COV_URL -e COV_USER=YOUR_COV_USER -e COVERITY_PASSPHRASE=YOUR_COVERITY_PASSPHRASE \
        coverity-scan https://github.com/WebGoat/WebGoat.git develop
```
