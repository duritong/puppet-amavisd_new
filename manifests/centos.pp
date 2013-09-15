class amavisd_new::centos inherits amavisd_new::base {
  Package['unarj']{
    name => 'arj',
  }
  file{'/etc/amavisd/amavisd.conf':
    source => [ "puppet:///modules/site_amavisd_new/${::fqdn}/amavisd.conf",
                "puppet:///modules/site_amavisd_new/${::operatingsystem}.${::operatingsystemmajrelease}/amavisd.conf",
                "puppet:///modules/site_amavisd_new/amavisd.conf",
                "puppet:///modules/amavisd_new/amavisd.conf" ],
    require => Package['amavisd-new'],
    notify => Service['amavisd'],
    owner => root, group => 0, mode => 0644;
  }
}
