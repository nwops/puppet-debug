[![Build Status](https://travis-ci.org/nwops/puppet-debugger-module.svg?branch=master)](https://travis-ci.org/nwops/puppet-debugger-module)

# Puppet Debug
This module contains a function called `debug::break()` and is for use with the
[puppet-debugger gem](https://github.com/nwops/puppet-debugger).

The function is used for starting the puppet debugger from inside the puppet code.

Why is this important?  Puppet code is getting more complex and in order to understand
the code you need to get inside the compiler look around at the variables, scope and
available functions.  

The debugger is extremely helpful in understanding the puppet language and your puppet code.
Think ruby pry but for puppet code.  

The function will inject the scope, node and environment data into the debugger
allowing you to poke around to see variables, functions, facts, classes, and resources defined in the current scope.

## Requirements
Ensure you have installed the puppet-debugger gem `gem install puppet-debugger`
or place this in your Gemfile `gem 'puppet-debugger', '>= 0.4'` for your puppet module.

This also requires puppet 3.8+ with future parser enabled.

You will also want to include this module in your fixtures file if using for rspec-puppet
unit testing.

```
debugger:
   repo: https://github.com/nwops/puppet-debugger-module
```

## Usage
**DO NOT RUN THIS ON YOUR PUPPET SERVER OR IN PRODUCTION**

Planes will fall out of the sky, and kittens will die.  Do you really want that?
Although there is a safety mechanism to prevent the this function from being called
under a daemonized puppet run so it is not all that bad.  

In order to start the puppet-debugger from within code just place the `debug::break()`
function inside your manifest code where you want the scope to be injected.
This will automatically call the debugger `whereami` command and show where in the code
the `debug::break()` function was called from.  This makes it obvious where in the code
you are evaluating from.  This gives you the ability to step through your code.  To goto
the next iteration just use the `exit` command and the compiler will continue to compile where it previously left of.

You can access variables just as you would when writing puppet code.  So once inside
the debugger session type `$some_var_name`

Example:

```puppet
class debugger::debugger_test(
  $var1 = 'value1',
  $var2 = ['value1', 'value2', 'value3']
)
{
  # dummy resources so we can show list of resources
  file{'/tmp/test.txt': ensure => present, mode => '0755'}
  service{'httpd': ensure => running}

  # how to find values with an empheral scope
  $var2.each | String $item | {
    file{"/tmp/${item}": ensure => present}
    debug::break({'run_once' => true})
  }
  debug::break({'run_once' => true})
  if $var1 == 'value1' {
    debug::break({'run_once' => true})
  }
}
```

Example Debugger session when inside the each block.  Notice the item variable.

```ruby
Ruby Version: 2.3.1
Puppet Version: 4.7.0
Puppet Debugger Version: 0.4.0
Created by: NWOps <corey@nwops.io>
Type "exit", "functions", "vars", "krt", "whereami", "facts", "resources", "classes",
     "play", "classification", "reset", or "help" for more information.

          8:   service{'httpd': ensure => running}
          9:
         10:   # how to find values with an empheral scope
         11:   $var2.each | String $item | {
         12:     file{"/tmp/${item}": ensure => present}
      => 13:     debug::break({'run_once' => false})
         14:   }
         15:   debug::break({'run_once' => false})
         16:   if $var1 == 'value1' {
         17:     debug::break({'run_once' => false})
         18:   }
1:>> $item
 => "value1"
>>
```

If using with rspec-puppet, only the facts you define in your test suite will be present in the debugger.

For more information on how to use the puppet debugger please refer to the [documentation](https://github.com/nwops/puppet-debugger)

## Troubleshooting
This module and puppet-debugger gem are very new, there will be bugs.  Please
file them at [puppet-debugger gem](https://github.com/nwops/puppet-debugger/issues).
