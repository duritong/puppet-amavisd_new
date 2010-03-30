class amavisd-new::centos inherits amavisd-new::base {
  Package['unarj']{
    name => 'arj',
  }
  file{'/etc/amavisd/amavisd.conf':
    source => [ "puppet://$server/modules/site-amavisd-new/${fqdn}/amavisd.conf",
                "puppet://$server/modules/site-amavisd-new/amavisd.conf",
                "puppet://$server/modules/amavisd-new/amavisd.conf" ],
    require => Package['amavisd-new'],
    owner => root, group => 0, mode => 0644;
  }
}
