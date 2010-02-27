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
