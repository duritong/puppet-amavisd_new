# basic things for amavisd-new
class amavisd_new::base {
  #unrar packages for amavis
  require unzip
  require unrar
  ensure_packages(['cabextract', 'freeze', 'zoo', 'unarj', 'lz4'])

  package { 'amavis':
    ensure  => installed,
    require => Package['cabextract', 'freeze', 'zoo', 'unarj', 'lz4'],
  } -> service { 'amavisd':
    ensure => running,
    enable => true,
  }
}
