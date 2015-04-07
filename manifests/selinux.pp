# amavisd/antivir should be able to scan
# the system
class amavisd_new::selinux {
  selboolean{
    'antivirus_can_scan_system':
      value      => 'on',
      persistent => true,
  }
}
