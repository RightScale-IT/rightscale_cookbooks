maintainer       "RightScale, Inc."
maintainer_email "support@rightscale.com"
license          "Copyright RightScale, Inc. All rights reserved."
description      "Manages the Git fast version control system"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "13.4.0"

# supports "centos", "~> 5.8", "~> 6"
# supports "redhat", "~> 5.8"
# supports "ubuntu", "~> 10.04", "~> 12.04"

depends "git"
depends "repo"

recipe  "repo_git::default",
  "Installs \"git\" package."
