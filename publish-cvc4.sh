#!/bin/bash

set -e

if [ -z "$1" ] ; then
	echo "Path to CVC4 needs to be given!"
	exit 1
fi

IVY="$(pwd)"
DIR="$1"
JAR=("$DIR"/builds/*/production/src/bindings/CVC4.jar)
LIBCVC4=("$DIR"/builds/*/production/lib/libcvc4.so)
LIBCVC4JNI=("$DIR"/builds/*/production/src/bindings/java/.libs/libcvc4jni.so)
LIBCVC4PARSER=("$DIR"/builds/*/production/lib/libcvc4parser.so)

JAVA_CPPFLAGS='-I/usr/lib/jvm/java-openjdk/include -I/usr/lib/jvm/java-openjdk/include/linux'
ANTLR="$1/antlr-3.4/bin/antlr3"

# build and copy version with assertions
pushd "$DIR"
VERSION="$(git describe --tags)"
# make clean
env ANTLR="$ANTLR" JAVA_CPPFLAGS="$JAVA_CPPFLAGS" ./configure production --enable-language-bindings="java" --with-antlr-dir="$1/antlr-3.4"
#Now just type make, followed by make check or make install, as you like.
# make
cp "${JAR[0]}"           "$IVY/libs/cvc4/cvc4-$VERSION.jar"
cp "${LIBCVC4[0]}"       "$IVY/libs/cvc4/libcvc4-$VERSION.so"
cp "${LIBCVC4JNI[0]}"    "$IVY/libs/cvc4/libcvc4jni-$VERSION.jar"
cp "${LIBCVC4PARSER[0]}" "$IVY/libs/cvc4/libcvc4parser-$VERSION.jar"
popd

./publish.sh cvc4 -publishpattern "[artifact]-[revision](-[classifier]).[ext]" -revision "$VERSION"
