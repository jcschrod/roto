PROJECT = Roto
SRC_DIR = src
BUILD_DIR = .
MAIN = jquery.roto
BEZ = lib/bez/jquery.bez.min.js

JS_ENGINE ?= `which node nodejs`
COMPILER ?= `which uglifyjs`

VERSION = $(shell git describe --tags --long | sed s/\-/\./)
YEAR = $(shell date +"%Y")

all: main min bez clean

nomin: main bez clean

main: submodules version

submodules:
	@@echo "Updating submodules"
	@@git submodule init
	@@git submodule update
	@@git submodule foreach "git checkout master"
	@@git submodule foreach "git pull"
	@@git submodule summary

version:
	@@echo "Setting version number (${VERSION}) and year (${YEAR})"
	@@sed 's/@VERSION/${VERSION}/' <${SRC_DIR}/${MAIN}.js | sed 's/@YEAR/${YEAR}/' > ${BUILD_DIR}/${MAIN}.tmp

min:
	@@if test ! -z ${JS_ENGINE} && test ! -z ${COMPILER}; then \
	echo "Minifying ${PROJECT}"; \
	${COMPILER} ${BUILD_DIR}/${MAIN}.tmp > ${BUILD_DIR}/${MAIN}.min.js; \
	else \
		echo "You must have NodeJS and UglifyJS installed in order to minify ${PROJECT}."; \
	fi

bez:
	@@echo "Attaching Bez to Roto"
	@@cat ${BEZ} ${MAIN}.min.js > ${MAIN}.tmp
	@@cp ${MAIN}.tmp ${MAIN}.min.js

clean:
	@@echo "Removing temp files"
	@@rm -f ${BUILD_DIR}/${MAIN}.tmp
	@@echo "Done"