Name:           astyle
Version:        2.04
Release:        1%{?dist}
Summary:        Source code formatter for C-like programming languages

Group:          Development/Tools
License:        LGPLv3+
URL:            http://astyle.sourceforge.net/
Source0:        http://downloads.sourceforge.net/%{name}/%{name}_%{version}_linux.tar.gz

BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

%description
Artistic Style is a source code indenter, source code formatter, and
source code beautifier for the C, C++, C# and Java programming
languages.


%prep
%setup -q -n %{name}

%build
g++ -o astyle $RPM_OPT_FLAGS src/*.cpp
chmod a-x src/*
chmod a-x doc/*


%install
rm -rf $RPM_BUILD_ROOT
%{_bindir}/install -p -D -m 755 astyle $RPM_BUILD_ROOT%{_bindir}/astyle


%clean
rm -rf $RPM_BUILD_ROOT


%files
%defattr(-,root,root,-)
%{_bindir}/astyle

%doc doc/*.html

%changelog
* Tue Nov  5 2013 Thomas Spura <tomspur@fedoraproject.org> - 2.04-1
- update to new version (fixes #1025982, #996008)

* Tue Jul 30 2013 Thomas Spura <tomspur@fedoraproject.org> - 2.03-1
- update to new version (fixes #990162)

* Wed Feb 13 2013 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 2.02.1-4
- Rebuilt for https://fedoraproject.org/wiki/Fedora_19_Mass_Rebuild

* Wed Jul 18 2012 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 2.02.1-3
- Rebuilt for https://fedoraproject.org/wiki/Fedora_18_Mass_Rebuild

* Thu Jan 12 2012 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 2.02.1-2
- Rebuilt for https://fedoraproject.org/wiki/Fedora_17_Mass_Rebuild

* Sun Dec  4 2011 Thomas Spura <tomspur@fedoraproject.org> - 2.02.1-1
- update to new version

* Mon Feb 07 2011 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 2.01-2
- Rebuilt for https://fedoraproject.org/wiki/Fedora_15_Mass_Rebuild

* Wed Dec  1 2010 Thomas Spura <tomspur@fedoraproject.org> - 2.01-1
- update to new version

* Sat Jan 30 2010 Thomas Spura <tomspur@fedoraproject.org> - 1.24-1
- update to new version
- change license to LGPLv3+ (changed since 1.23, but missed there)

* Tue Oct 13 2009 Thomas Spura <tomspur@fedoraproject.org> - 1.23-1
- Update to new version
- patch from Sep 24 2008 not needed anymore for gcc-4.4

* Fri Jul 24 2009 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 1.21-11
- Rebuilt for https://fedoraproject.org/wiki/Fedora_12_Mass_Rebuild

* Mon Feb 23 2009 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 1.21-10
- Rebuilt for https://fedoraproject.org/wiki/Fedora_11_Mass_Rebuild

* Wed Sep 24 2008 Debarshi Ray <rishi@fedoraproject.org> - 1.21-9
- Fixed build failure with gcc-4.3. Closes Red Hat Bugzilla bug #433971.

* Wed May 21 2008 Tom "spot" Callaway <tcallawa@redhat.com> - 1.21-8
- fix license tag

* Mon Feb 18 2008 Fedora Release Engineering <rel-eng@fedoraproject.org> - 1.21-7
- Autorebuild for GCC 4.3

* Tue Aug 28 2007 Fedora Release Engineering <rel-eng at fedoraproject dot org> - 1.21-6
- Rebuild for selinux ppc32 issue.

* Mon Jul 2 2007 Adam M. Dutko <gnome at dux-linux org> 1.21-5
- Fixed sourceforge Source0 link.
- Updated to 1.21.

* Tue Jun 19 2007 Adam M. Dutko <gnome at dux-linux org> 1.20.2-4
- Removed macros from changelog
- Formatted changelog from 1.20.2-2

* Tue Jun 19 2007 Adam M. Dutko <gnome at dux-linux org> 1.20.2-3
- Changed licensing to LGPL from GPL
- Removed execute bit from src/*
- Used bindir/install instead of /usr/bin/install

* Thu Jun 14 2007 Mary Ellen Foster <mefoster gmail com> 1.20.2-2
- Modifications from Ralf Corsepius (thanks!):
- Eliminated use of build/Makefile; just compile and install directly
- Use bindir rather than /usr/bin

* Sat May 12 2007 Adam Monsen <haircut@gmail.com> 1.20.2-1
- removed Makefile patch

* Thu Sep 21 2006 Mary Ellen Foster <mefoster gmail com> 1.19-1
- Initial package
