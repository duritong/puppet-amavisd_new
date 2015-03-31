# amavisd/antivir should be able to scan
# the system
class amavisd_new::selinux {
  if ($::osfamily == 'RedHat') and (versioncmp($::operatingsystemmajrelease,'7') < 0) {
    selboolean{
      'antivirus_can_scan_system':
        value      => 'on',
        persistent => true,
    }
  }
}
