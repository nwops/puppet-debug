class debug (
  $gem_provider = 'gem'

) {
  package{'puppet-debugger':
    ensure   => present,
    provider => $gem_provider,
  }
}
