class amavisd-new::base {
  #unrar packages for amavis
  package{ [ 'arc', 'cabextract', 'freeze', 'unrar', 'lha', 'zoo', 'unarj' ]:
    ensure => installed,
  }

  package{'amavisd-new':
    ensure => installed,
    require => Package['arc', 'cabextract', 'freeze', 'unrar', 'lha', 'zoo', 'unarj'],
  }

  service{'amavisd':
    ensure => running,
    enable => true,
    hasstatus => true,
    require => Package['amavisd-new'],
  }
}	
