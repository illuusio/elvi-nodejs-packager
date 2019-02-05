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

%fdupes %{buildroot}

%files
%dir %{_libexecdir}/node_modules
%{_libexecdir}/node_modules/#modname#

%changelog
