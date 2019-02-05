#
# spec file for package node
#
# Copyright (c) 2018 SUSE LINUX GmbH, Nuernberg, Germany.
#
# All modifications and additions to the file contributed by third parties
# remain the property of their copyright owners, unless otherwise agreed
# upon. The license for this file, and modifications and additions to the
# file, is the same license as for the pristine package itself (unless the
# license for the pristine package is not an Open Source License, in which
# case the license is the MIT License). An "Open Source License" is a
# license that conforms to the Open Source Definition (Version 1.9)
# published by the Open Source Initiative.

# Please submit bugfixes or comments via http://bugs.opensuse.org/
#


%define mod_name #modname#
Name:           #name#
Version:        #version#
Release:        0
Summary:        #summary#
License:        #licenses#
# FIXME: use correct group, see "https://en.opensuse.org/openSUSE:Package_group_guidelines"
Group:          Development/Languages/NodeJS
URL:            #homepage#
Source0:        %{mod_name}-%{version}.tar.xz
BuildRequires:  fdupes
BuildRequires:  jq
BuildRequires:  nodejs
Requires:       nodejs
Requires:       nodejs-package-config

%description
Nodejs application: #summary#

%prep
%setup -q -n %{mod_name}

%build

%install
mkdir -p %{buildroot}%{_libexecdir}/node_modules/%{mod_name}
cp -r * %{buildroot}%{_libexecdir}/node_modules/%{mod_name}

PACKAGE_OBJ=$(jq .bin package.json)

if [ "${PACKAGE_OBJ}" != "null" ]
then
   PACKAGE_OBJ_KEYS=$(echo "${PACKAGE_OBJ}" | jq 'to_entries[0]')
   PACKAGE_OBJ_BIN=$(echo "${PACKAGE_OBJ_KEYS}" | jq .key | tr -d '"')
   PACKAGE_OBJ_LOCATION=$(echo "${PACKAGE_OBJ_KEYS}" | jq .value | tr -d '"')

   echo "Linking to %{_libexecdir}/node_modules/.bin/${PACKAGE_OBJ_BIN} from ${PACKAGE_OBJ_LOCATION}"
   mkdir -p %{buildroot}%{_libexecdir}/node_modules/.bin
   ln -sf %{_libexecdir}/node_modules/%{mod_name}/${PACKAGE_OBJ_LOCATION} %{buildroot}%{_libexecdir}/node_modules/.bin/${PACKAGE_OBJ_BIN}
fi

%fdupes %{buildroot}

%files
%dir %{_libexecdir}/node_modules
%{_libexecdir}/node_modules/#modname#
%{_libexecdir}/node_modules/.bin

%changelog
