Puppet::Functions.create_function(:'debug::break', Puppet::Functions::InternalFunction) do
  # the function below is called by puppet and and must match
  # the name of the puppet function above.

  def initialize(scope, loader)
    super
    @debugger_stack_count = 0
  end

  dispatch :break do
    scope_param
    optional_param 'Hash', :options
  end

  def break(scope, options = {})
    require 'puppet-debugger'      
    if $stdout.isatty
      options = options.merge(scope: scope)
      # forking the process allows us to start a new debugger shell
      # for each occurrence of the start_debugger function
      pid = fork do
        # required in order to use convert puppet hash into ruby hash with symbols
        options = options.each_with_object({}) { |(k, v), data| data[k.to_sym] = v; }
        options[:source_file], options[:source_line] = stacktrace.first
        # suppress future debugger help screens
        @debugger_stack_count += 1
        # suppress future debugger help screens since we probably started from the debugger, so look for this string
        # in the filename to detect
        @debugger_stack_count += 1 if options[:source_file] =~ %r{puppet_debugger_input}
        options[:quiet] = true if @debugger_stack_count > 1
        ::PuppetDebugger::Cli.start_without_stdin(options)
      end
      Process.wait(pid)
      @debugger_stack_count += 1
    else
      Puppet.warning 'debug::breakpoint(): refusing to start the debugger on a daemonized master'
    end
  end

  # returns a stacktrace of called puppet code
  def stacktrace
    if Gem::Version.new(Puppet.version) >= Gem::Version.new('4.6')
      Puppet::Pops::PuppetStack.stacktrace.find_all {|line| ! line.include?('unknown') }
    else
      old_stacktrace
    end
  end

  # @return [String] - file path to source code
  # @return [Integer] - line number of called function
  # This method originally came from the puppet 4.6 codebase and was backported here
  # for compatibility with older puppet versions
  # The basics behind this are to find the `.pp` file in the list of loaded code
  # This is only here for people who can't upgrade for some reason.
  def old_stacktrace
    result = caller.each_with_object([]) { |loc, memo|
      next unless loc =~ %r{\A(.*\.pp)?:([0-9]+):in\s(.*)}
      # if the file is not found we set to code
      # and read from Puppet[:code]
      # $3 is reserved for the stacktrace type
      memo << [Regexp.last_match(1).nil? ? :code : Regexp.last_match(1), Regexp.last_match(2).to_i]
    }
  end
end
