# manage amavisd-new stuff
# Copyright (C) 2007 admin@immerda.ch
# GPLv3
# this module is part of a whole bunch of modules, please have a look at the exim module

class amavisd_new(
  $viruscheck = hiera('amavis_viruscheck',false),
  $spamcheck = hiera('amavis_spamcheck',false)
) {
  case $::operatingsystem {
    gentoo: { include amavisd_new::gentoo }
    centos: { include amavisd_new::centos }
    debian,ubuntu: { include amavisd-new::debian }
    default: { include amavisd_new::base }
  }

  if hiera('use_munin',false) {
    include amavisd_new::munin
  }
}
