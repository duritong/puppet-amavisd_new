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
    require => Package['amavisd-new'],
  }

  require ::clamav
  if versioncmp($::operatingsystemmajrelease,'6') > 0 {
    Package['zoo']{
      name => 'unzoo',
    }
    File_line['enable_freshclam'] -> Service['clamd.amavisd']{
      name    => 'clamd@amavisd',
    }
    # http://www.server-world.info/en/note?os=CentOS_7&p=mail&f=6
    package{'clamav-server-systemd':
      ensure => present,
      before => Service['clamd.amavisd'],
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
    concat{'/etc/systemd/system/clamd@amavisd.service':
      owner  => root,
      group  => 0,
      mode   => '0644',
      notify => [ Exec['systemctl-daemon-reload'],Service['clamd.amavisd'], ],
    }
    Exec['systemctl-daemon-reload'] -> Service['clamd.amavisd']
    concat::fragment{
      'systemd-clamd-base':
        target  => '/etc/systemd/system/clamd@amavisd.service',
        source  => '/usr/lib/systemd/system/clamd@.service',
        require => Package['clamav-server-systemd'],
        order   => '010';
      'systemd-clamd-install':
        target  => '/etc/systemd/system/clamd@amavisd.service',
        content => "\n[Install]\nWantedBy=multi-user.target\n",
        order   => '020',
    }

  }

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
