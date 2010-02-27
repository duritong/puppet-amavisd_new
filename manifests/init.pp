# modules/amavisd-new/manifests/init.pp - manage amavisd-new stuff
# Copyright (C) 2007 admin@immerda.ch
# GPLv3
# this module is part of a whole bunch of modules, please have a look at the exim module

class amavisd-new {
  # defaults
  case $amavis_viruscheck { "": { $amavis_viruscheck = "false" } }
  case $amavis_spamcheck { "": { $amavis_spamcheck = "false" } }

  case $operatingsystem {
    gentoo: { include amavisd-new::gentoo }
    debian,ubuntu: { include amavisd-new::debian }
    default: { include amavisd-new::base }
  }
}

class amavisd-new::base {
  #unrar packages for amavis
  package{ [ 'arc', 'cabextract', 'freeze', 'unrar', 'lha', 'zoo', 'unarj' ]:
    ensure => installed,
  }

  package{'amavisd-new':
    ensure => installed,
    require => Package['arc', 'cabextract', 'freeze', 'unrar', 'lha', 'zoo', 'unarj'],
  }

  service{'amavisd':
    ensure => running,
    enable => true,
    hasstatus => true,
    require => Package['amavisd-new'],
  }
}	

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

class amavisd-new::gentoo inherits amavisd-new::base {
  Package['amavisd-new']{
    category => 'mail-filter',
  }
  #archive
  Package['arc', 'cabextract', 'freeze', 'unrar', 'unarj', 'lha', 'zoo']{
    category => 'app-arch',
  }
}
