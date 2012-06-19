class amavisd_new::munin {
  munin::plugin::deploy{'amavis_':
    source => "amavisd_new/munin/amavis_",
    ensure => absent,
  }

  case $::operatingsystem {
    centos: { $munin_amavis_db_location = '/var/spool/amavisd/db/' }
    default: { $munin_amavis_db_location = '/var/lib/amavis/db' }
  }

  munin::plugin{ [ 'amavis_cache', 'amavis_content', 'amavis_time' ]:
    require => Munin::Plugin::Deploy['amavis_'],
    ensure => 'amavis_',
    config => "env.amavis_db_home ${munin_amavis_db_location}\nuser amavis",
  }
}
