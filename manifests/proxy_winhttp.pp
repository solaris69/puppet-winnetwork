# == Class: winnetwork::proxy
#
# Manages proxy and bypass list for WINHTTP library only
#
# === Parameters
#
# [*None*]
#
# === Examples
#
#  include winnetwork::proxy_winhttp
#
# === Authors
#
# songan.bui@thomsonreuters.com
#
# === Comment
#
# 
#
class winnetwork::proxy_winhttp (
  $proxy_host   = '0.0.0.1',
  $proxy_port   = '80',
  $proxy_bypass = 'localhost;127.0.0.1;',
) {
  case $::osfamily {
    'windows': {
      file{ 'c:/vc/check_winhttp_proxy.ps1': ensure => file, content => template('winnetwork/check_winhttp_proxy.ps1.erb'), require => File['c:/vc']} ->
      exec { 'WINHTTP proxy server':
        path     => $::path,
        command  => "& netsh winhttp set proxy \"${proxy_host}:${proxy_port}\" \"${proxy_bypass}\"",
        unless   => 'C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -Executionpolicy Unrestricted -File c:/vc/check_winhttp_proxy.ps1',
#        provider => powershell,
      }
    }
    default: { fail("${::osfamily} is not a supported platform.") }
  }
}