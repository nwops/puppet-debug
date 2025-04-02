class debug::debug_test (
  String $var1 = 'value1',
  Array[String] $var2 = ['value1', 'value2', 'value3']
) {
  if $var1 == 'failme' {
    debug::break({ 'run_once' => true })
    fail('dsafsd')
  }
  # dummy resources so we can show list of resources
  file { '/tmp/test.txt': ensure => file, mode => '0755' }
  service { 'httpd': ensure => running }

  # how to find values with an empheral scope
  $var2.each | String $item | {
    file { "/tmp/${item}": ensure => file }
    debug::break({ 'run_once' => false })
  }
  debug::break({ 'run_once' => true })
  if $var1 == 'value1' {
    debug::break({ 'run_once' => true })
  }
}
