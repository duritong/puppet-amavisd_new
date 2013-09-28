# manage amavisd munin plugins
class amavisd_new::munin {
  munin::plugin::deploy{'amavis_':
    ensure => absent,
    source => 'amavisd_new/munin/amavis_',
  }

  case $::operatingsystem {
    centos: { $munin_amavis_db_location = '/var/spool/amavisd/db/' }
    default: { $munin_amavis_db_location = '/var/lib/amavis/db' }
  }

  munin::plugin{ [ 'amavis_content', 'amavis_time' ]:
    ensure  => 'amavis_',
    require => Munin::Plugin::Deploy['amavis_'],
    config  => "env.amavis_db_home ${munin_amavis_db_location}\nuser amavis",
  }
  # this feature is only available in versions available on that system
  if ($::operatingsystem == 'CentOS') and ($::operatingsystemmajrelease < 6) {
    munin::plugin{'amavis_cache':
      ensure  => 'amavis_',
      require => Munin::Plugin::Deploy['amavis_'],
      config  => "env.amavis_db_home ${munin_amavis_db_location}\nuser amavis",
    }
  }
}
