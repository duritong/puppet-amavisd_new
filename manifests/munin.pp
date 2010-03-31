class amavisd-new::munin {
  munin::plugin::deploy{'amavis_':
    source => "amavisd-new/munin/amavis_",
    ensure => absent,
  }
  
  case $operatingsystem {
    centos: { $munin_amavis_db_location = '/var/spool/amavisd/db/' }
    default: { $munin_amavis_db_location = '/var/lib/amavis/db' }
  }

  munin::plugin{ [ 'amavis_state', 'amavis_content', 'amavis_time' ]:
    require => Munin::Plugin::Deploy['amavis_'],
    ensure => 'amavis_',
    config => "env.amavis_db_home ${munin_amavis_db_location}\nuser amavis",
  }
}
