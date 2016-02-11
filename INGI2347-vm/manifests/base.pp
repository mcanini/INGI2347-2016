Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

File { owner => "root", group => "root" }

#--apt-update Triggers-----

exec { "apt-update":
    command => "sudo apt-get update",
}

Exec["apt-update"] -> Package <| |> #This means that an apt-update command has to be triggered before any package is installed

package { ['linux-image-generic', 'build-essential', 'ubuntu-standard',
		'openssh-server', 'gdb', 'libacl1-dev', 'python', 'vim', 'emacs',
		'curl', 'libssl-dev', 'netcat', 'execstack', 'python-sqlalchemy',
		'python-setuptools', 'python-flask', 'python-lxml', 'xvfb', 'tmux',
		'valgrind', 'firefox', 'git', 'phantomjs', 'open-vm-toolbox',
		'python-pysqlite2', 'slimit', 'open-vm-tools', 'autoconf', 'dos2unix']:
        ensure => 'present'
}

package { 'ubuntu-release-upgrader-core':
        ensure => 'purged'
}

#exec {"vm-fixup":
#        command => "/vagrant/vm-fixup.sh",
#        user => root,
#        creates => "/home/vagrant/.gdbinit"
#}
