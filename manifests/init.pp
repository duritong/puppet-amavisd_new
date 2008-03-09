# modules/amavisd-new/manifests/init.pp - manage amavisd-new stuff
# Copyright (C) 2007 admin@immerda.ch
# GPLv3
# this module is part of a whole bunch of modules, please have a look at the exim module

# modules_dir { "amavisd-new": }

class amavisd-new {
    case $operatingsystem {
        gentoo: { include amavisd-new::gentoo }
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
            Package[unarj],
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
    package{'unarj':
        ensure => installed
    }
    package{'lha':
        ensure => installed
    }
    package{'zoo':
        ensure => installed
    }

    service{amavisd:
        ensure => running,
        enable => true,
        #hasstatus => true, #fixme!
        require => Package[amavisd-new],
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
}
