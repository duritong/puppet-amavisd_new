# debian specific things
class amavisd_new::debian inherits amavisd_new::base {
  # doesnt exist in debian lenny anymore, is package arj useful ?
  Package['unarj']{
    ensure => absent,
  }

  Service['amavisd']{
    name => 'amavis'
  }

  file {'/etc/amavis/conf.d/50-user':
    content => template('amavisd_new/debian/50-user'),
    require => Package['amavis'],
    notify  => Service['amavisd'],
    owner   => root,
    group   => 0,
    mode    => '0644';
  }
}
