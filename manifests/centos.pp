# centos specific things
class amavisd_new::centos inherits amavisd_new::base {
  Package['unarj']{
    name => 'arj',
  }
  file{'/etc/amavisd/amavisd.conf':
    require => Package['amavisd-new'],
    notify  => Service['amavisd'],
    owner   => root,
    group   => 0,
    mode    => '0644';
  }
  if $amavisd_new::config_content {
    File['/etc/amavisd/amavisd.conf']{
      content => $amavisd_new::config_content
    }
  } else {
    File['/etc/amavisd/amavisd.conf']{
      source => ["puppet:///modules/${amavisd_new::site_config}/${::fqdn}/amavisd.conf",
                "puppet:///modules/${amavisd_new::site_config}/${::operatingsystem}.${::operatingsystemmajrelease}/amavisd.conf",
                "puppet:///modules/${amavisd_new::site_config}/amavisd.conf",
                'puppet:///modules/amavisd_new/amavisd.conf' ]
    }
  }

  service{'clamd.amavisd':
    ensure  => running,
    enable  => true,
    require => [ Package['amavisd-new','clamd'],
                Exec['init-clamav-db'], ],
  }

  require ::clamav
  package{'clamd':
    ensure => present,
  }
  Package['zoo']{
    name => 'unzoo',
  }
  File_line['enable_freshclam'] -> Service['clamd.amavisd']{
    name    => 'clamd@amavisd',
  }
  file{
    '/etc/tmpfiles.d/clamd.amavisd.conf':
      content => "d /var/run/clamd.amavisd 0755 amavis amavis -\n",
      owner   => root,
      group   => 0,
      mode    => '0644',
      notify  => Service['clamd.amavisd'];
  }

  include ::systemd
  systemd::dropin_file{
    default:
      unit => 'clamd@amavisd.service';
    'amavisd-tunings.conf':
      content => "[Install]\nWantedBy=multi-user.target";
    'amavisd-startup-timeout.conf':
      content => "[Service]\nTimeoutStartSec = 300";
  } ~> Service['clamd.amavisd']
  Exec['systemctl-daemon-reload'] -> Service['clamd.amavisd']

  selinux::fcontext{
    '/var/spool/amavisd/\.razor/logs(/.*)?':
      setype  => 'antivirus_log_t',
      require => Package['amavisd-new'];
  } -> file{
    [ '/var/spool/amavisd/.razor','/var/spool/amavisd/.razor/logs' ]:
      ensure => directory,
      owner  => 'amavis',
      group  => 'amavis',
      mode   => '0640';
    '/var/spool/amavisd/.razor/razor-agent.conf':
      content => "logfile=/var/spool/amavisd/.razor/logs/razor-agent.log\n",
      owner   => 'amavis',
      group   => 'amavis',
      mode    => '0600';
  } -> file{'/etc/logrotate.d/razor':
    source => 'puppet:///modules/amavisd_new/logrotate/razor',
    owner  => root,
    group  => 0,
    mode   => '0644',
  } -> file{'/var/spool/amavisd/.razor/razor-agent.log':
    ensure => absent, # can be removed once this got rolled out
  }
  File['/var/spool/amavisd/.razor/logs']{
    seltype => 'antivirus_log_t',
  }
}
