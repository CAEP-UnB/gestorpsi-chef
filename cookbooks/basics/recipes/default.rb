PACKAGES = ['openssh-server', 'vim', 'git']

PACKAGES.each { |package_name|
  package "#{package_name}"
}
