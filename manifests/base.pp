# basic things for amavisd-new
class amavisd_new::base {
  #unrar packages for amavis
  require unzip
  require unrar
  package{ [ 'arc', 'cabextract', 'freeze', 'lha', 'zoo', 'unarj' ]:
    ensure => installed,
  }

  package{'amavisd-new':
    ensure  => installed,
    require => Package['arc', 'cabextract', 'freeze', 'lha', 'zoo', 'unarj' ],
  }

  service{'amavisd':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    require   => Package['amavisd-new'],
  }
}
