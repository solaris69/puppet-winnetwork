# == Class: winnetwork::firewall
#
# Manages firewall configuration
#
# === Parameters
#
# [*None*]
#
# === Examples
#
#  include winnetwork::firewall
#
# === Authors
#
# songan.bui@thomsonreuters.com
#
# === Comment
#
# 
#
class winnetwork::firewall (
  $disable_private = false,
  $disable_public = false,
) {
  case $::osfamily {
    'windows': {
      $private_state = $disable_private ? {
        true    => 'OFF',
        false   => 'ON',
        default => 'ON',
      }
      file{ 'c:/vc/check_private_firewall_state.ps1': ensure => file, content => template('winnetwork/check_private_firewall_state.ps1.erb'), require => File['c:/vc']} ->
      exec { 'private profile firewall':
        path     => $::path,
        command  => "& netsh advfirewall set private state ${private_state}",
        unless   => 'C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -Executionpolicy Unrestricted -File c:/vc/check_private_firewall_state.ps1',
#        provider => powershell,
      }

      $public_state = $disable_public ? {
        true    => 'OFF',
        false   => 'ON',
        default => 'ON',
      }
      file{ 'c:/vc/check_public_firewall_state.ps1': ensure => file, content => template('winnetwork/check_public_firewall_state.ps1.erb'), require => File['c:/vc']} ->
      exec { 'public profile firewall':
        path     => $::path,
        command  => "& netsh advfirewall set public state ${public_state}",
        unless   => 'C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -Executionpolicy Unrestricted -File c:/vc/check_public_firewall_state.ps1',
#        provider => powershell,
      }
    }
    default: { fail("${::osfamily} is not a supported platform.") }
  }
}