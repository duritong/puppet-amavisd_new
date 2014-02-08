# amavisd/antivir should be able to scan
# the system
class amavisd_new::selinux {
  if ($::osfamily == 'RedHat') and ($::operatingsystemmajrelease > 5) {
    selboolean{
      'antivirus_can_scan_system':
        value      => 'on',
        persistent => true,
    }
  }
}
