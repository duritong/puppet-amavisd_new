# manage amavisd-new stuff
# Copyright (C) 2007 admin@immerda.ch
# GPLv3
# this module is part of a whole bunch of modules, please have a look at the exim module

class amavisd_new(
  $viruscheck   = false,
  $spamcheck    = false,
  $manage_munin = false
) {
  case $::operatingsystem {
    gentoo: { include amavisd_new::gentoo }
    centos: { include amavisd_new::centos }
    debian,ubuntu: { include amavisd_new::debian }
    default: { include amavisd_new::base }
  }

  if $manage_munin {
    include amavisd_new::munin
  }
}
