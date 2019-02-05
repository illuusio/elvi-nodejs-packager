#!/bin/sh
#
# SPDX-License-Identifier: MIT 
#
# Copyright (c) 2019 Tuukka Pasanen <tuukka.pasanen@ilmi.fi>
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use,
# copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons
# to whom the Software is furnished to do so, subject to
# the following conditions:
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
# OR OTHER DEALINGS IN

mkdir -p packages
cd packages || exit

REMOVE_UNNEEDED="*.o \
    *.c \
    *.cpp \
    *.a \
    *.h \
    *.jar \
    *.node \
    *.yml \
    *.yaml \
    *.rej \
    *.orig \
    *.el \
    *.bak \
    *.swp \
    *~ \
    .*ignore \
    .git* \
    .*config \
    .*rc \
    .*lint* \
    .deps  \
    .*.json \
    .*.md \
    *.coffee \
    .*.js \
    .*output \
    .*Store \
    .*version \
    .HEADER \
    .project \
    .jscs*"

TAR_USER="abuild"
TAR_GROUP="abuild"

NPM_PACKAGES=$(cat ../package.txt)

while IFS= read -r package
do
    echo -n "package ${package} "
    PACKAGE_VERSION=$(npm view "${package}" version)
    PACKAGE_URL=$(npm view "${package}" repository.url)
    echo "version ${PACKAGE_VERSION}"
    mkdir -p "nodejs-${package}"
    npm install "${package}@${PACKAGE_VERSION}" --production --only="production" --global-style --no-package-lock
    cd node_modules || exit
    for file in ${REMOVE_UNNEEDED}
    do
        find . -type f -name "${file}" -exec rm -f "{}" \;
    done
    find . -type f -size 0 -exec rm "{}" \;
    find . -executable -type f -print0 | xargs -0 grep -vrIzl '^#![[:blank:]]*' | xargs chmod a-x
    find . -type f -exec sed -i "1 s#/usr/bin/env #/usr/bin/#g" {} \;
    find . -type f -exec sed -i "1 s#/usr/bin/bash#/bin/bash#g" {} \;
    find . -type f -exec sed -i "1 s#/usr/bin/spidermonkey-1.7#/bin/bash#g" {} \;

    tar --group="${TAR_GROUP}" --owner="${TAR_USER}" -c -J -f "../nodejs-${package}/${package}-${PACKAGE_VERSION}.tar.xz" "${package}"
    cd ..
    PACKAGE_DESC=$(jq .description "node_modules/${package}/package.json" | sed -e 's#"##g' -e 's#/#\\/#')
    PACKAGE_LICENSE=$(jq .license "node_modules/${package}/package.json" | sed -e 's#"##g')
    PACKAGE_OBJ=$(jq .bin "node_modules/${package}/package.json")
    echo "Description: '${PACKAGE_DESC}' (${PACKAGE_LICENSE})"
    if [ "${PACKAGE_OBJ}" != "null" ]
    then
        sed -e "s/#name#/nodejs-${package}/g" -e "s#\#homepage\##${PACKAGE_URL}#g" -e "s/#version#/${PACKAGE_VERSION}/g" -e "s/#modname#/${package}/g" -e "s/#summary#/${PACKAGE_DESC}/g" -e "s/#licenses#/${PACKAGE_LICENSE}/g" ../template/node.spec > "nodejs-${package}/nodejs-${package}.spec"
    else
        sed -e "s/#name#/nodejs-${package}/g" -e "s#\#homepage\##${PACKAGE_URL}#g" -e "s/#version#/${PACKAGE_VERSION}/g" -e "s/#modname#/${package}/g" -e "s/#summary#/${PACKAGE_DESC}/g" -e "s/#licenses#/${PACKAGE_LICENSE}/g" ../template/node-noscript.spec > "nodejs-${package}/nodejs-${package}.spec"
    fi

    rm -rf node_modules
done <<< "${NPM_PACKAGES}"
