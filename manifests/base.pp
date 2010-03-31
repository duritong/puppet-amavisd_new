class amavisd-new::base {
  #unrar packages for amavis
  package{ [ 'arc', 'cabextract', 'freeze', 'unrar', 'lha', 'zoo', 'unarj', 'unzip' ]:
    ensure => installed,
  }

  package{'amavisd-new':
    ensure => installed,
    require => Package['arc', 'cabextract', 'freeze', 'unrar', 'lha', 'zoo', 'unarj', 'unzip' ],
  }

  service{'amavisd':
    ensure => running,
    enable => true,
    hasstatus => true,
    require => Package['amavisd-new'],
  }
}	
