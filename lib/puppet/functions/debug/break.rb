begin
  require 'puppet-debugger'
  if ::PuppetDebugger::VERSION >= '0.4.0'
    Puppet.err('You must install the puppet-debugger gem version >= 0.4.0')
  end
rescue LoadError => e
  Puppet.err('You must install the puppet-debugger: gem install puppet-debugger')
end

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
    if $stdout.isatty
      options = options.merge({:scope => scope})
      # forking the process allows us to start a new debugger shell
      # for each occurrence of the start_debugger function
      pid = fork do
        # required in order to use convert puppet hash into ruby hash with symbols
        options = options.inject({}){|data,(k,v)| data[k.to_sym] = v; data}
        options[:source_file], options[:source_line] = stacktrace.last
        # suppress future debugger help screens
        @debugger_stack_count = @debugger_stack_count + 1
        # suppress future debugger help screens since we probably started from the debugger, so look for this string
        # in the filename to detect
        @debugger_stack_count = @debugger_stack_count + 1 if options[:source_file] =~ /puppet_debugger_input/
        options[:quiet] = true if @debugger_stack_count > 1
        ::PuppetDebugger::Cli.start_without_stdin(options)
      end
      Process.wait(pid)
      @debugger_stack_count = @debugger_stack_count + 1
    else
      Puppet.warning 'debug::breakpoint(): refusing to start the debugger on a daemonized master'
    end
  end

  # returns a stacktrace of called puppet code
  # @return [String] - file path to source code
  # @return [Integer] - line number of called function
  # This method originally came from the puppet 4.6 codebase and was backported here
  # for compatibility with older puppet versions
  # The basics behind this are to find the `.pp` file in the list of loaded code
  def stacktrace
    result = caller().reduce([]) do |memo, loc|
      if loc =~ /\A(.*\.pp)?:([0-9]+):in\s(.*)/
        # if the file is not found we set to code
        # and read from Puppet[:code]
        # $3 is reserved for the stacktrace type
        memo << [$1.nil? ? :code : $1, $2.to_i]
      end
      memo
    end.reverse
  end
end
