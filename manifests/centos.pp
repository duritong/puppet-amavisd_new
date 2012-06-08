class amavisd_new::centos inherits amavisd_new::base {
  Package['unarj']{
    name => 'arj',
  }
  file{'/etc/amavisd/amavisd.conf':
    source => [ "puppet:///modules/site_amavisd-new/${::fqdn}/amavisd.conf",
                "puppet:///modules/site_amavisd-new/amavisd.conf",
                "puppet:///modules/amavisd-new/amavisd.conf" ],
    require => Package['amavisd-new'],
    notify => Service['amavisd'],
    owner => root, group => 0, mode => 0644;
  }
}
