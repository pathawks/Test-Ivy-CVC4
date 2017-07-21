#!/bin/sh

LIB="$1"
shift

if [ -z "$LIB" ]; then
	echo "Please see HowTo.txt for information on how to use this script."
	exit 1
fi

if [ ! -d "libs/$LIB" ]; then
	echo "Wrong library name $LIB"
	exit 1
fi

cd "libs/$LIB"

java -Dbasedir="$(readlink -f ../../)" \
     -Divy.default.resolver=CVC4 \
     -jar ../../repository/org.apache.ivy/ivy/ivy-2.4.0.jar \
     -settings ../../ivysettings.xml \
     -status release \
     -publish CVC4 \
     -retrieve CVC4 \
     -ivy ivy.xml \
     "$@"

cd ../..
