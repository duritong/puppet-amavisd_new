# modules/amavisd-new/manifests/init.pp - manage amavisd-new stuff
# Copyright (C) 2007 admin@immerda.ch
# GPLv3
# this module is part of a whole bunch of modules, please have a look at the exim module

class amavisd-new {
  # defaults
  case $amavis_viruscheck {
    "": { $amavis_viruscheck = "false" }
  }

  case $amavis_spamcheck {
    "": { $amavis_spamcheck = "false" }
  }

  case $operatingsystem {
    gentoo: { include amavisd-new::gentoo }
    debian,ubuntu: { include amavisd-new::debian }
    default: { include amavisd-new::base }
  }
}

class amavisd-new::base {
  package{'amavisd-new':
    ensure => installed,
    require => [ 
      Package[arc],
      Package[cabextract],
      Package[freeze],
      Package[unrar],
      #Package[unarj],   # doesnt exist in debian lenny anymore, is package arj useful ?
      Package[lha],
      Package[zoo]
    ],
  }
  #unrar packages for amavis
  package{'arc':
    ensure => installed
  }
  package{'cabextract':
    ensure => installed
  }
  package{'freeze':
    ensure => installed
  }
  package{'unrar':
    ensure => installed
  }
  package{'lha':
    ensure => installed
  }
  package{'zoo':
    ensure => installed
  }

  case $operatingsystem {
    debian: {$amavisd_servicename = "amavis" }
    default: {$amavisd_servicename = "amavisd"}
  }

  service{amavisd:
	  name => $amavisd_servicename,
  	ensure => running,
	  enable => true,
  	hasstatus => true,
	  require => Package[amavisd-new],
  }
}	

class amavisd-new::debian inherits amavisd-new::base {
  file {"/etc/amavis/conf.d/50-user":
    content => template("amavisd-new/debian/50-user"),
    mode => 0644, owner => root, group => root,
    require => Package[amavisd-new],
    notify => Service[amavisd];
  }
}

class amavisd-new::gentoo inherits amavisd-new::base {
  Package[amavisd-new]{
    category => 'mail-filter',
  }
  #archive
  Package[arc]{
    category => 'app-arch',
  }
  Package[cabextract]{
    category => 'app-arch',
  }
  Package[freeze]{
    category => 'app-arch',
  }
  Package[unrar]{
    category => 'app-arch',
  }
  Package[unarj]{
    category => 'app-arch',
  }
  Package[lha]{
    category => 'app-arch',
  }
  Package[zoo]{
    category => 'app-arch',
  }

  package{'unarj':
    ensure => installed
  }
}
