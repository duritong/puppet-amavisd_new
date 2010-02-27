class amavisd-new::gentoo inherits amavisd-new::base {
  Package['amavisd-new']{
    category => 'mail-filter',
  }
  #archive
  Package['arc', 'cabextract', 'freeze', 'unrar', 'unarj', 'lha', 'zoo']{
    category => 'app-arch',
  }
}
