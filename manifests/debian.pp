class amavisd-new::debian inherits amavisd-new::base {
  # doesnt exist in debian lenny anymore, is package arj useful ?
  Package['unarj']{
    ensure => absent,
  }

  Service['amavisd']{
    name => 'amavis'
  }

  file {"/etc/amavis/conf.d/50-user":
    content => template("amavisd-new/debian/50-user"),
    require => Package['amavisd-new'],
    notify => Service['amavisd'],
    owner => root, group => 0, mode => 0644;
  }
}
