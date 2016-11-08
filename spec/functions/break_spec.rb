require 'spec_helper'
require 'puppet/pops'
require 'puppet/loaders'

describe 'debug::break' do

  #it { is_expected.to run.with_params({'run_once' => true}).and_return('') }

  # before(:all) do
  #   loaders = Puppet::Pops::Loaders.new(Puppet::Node::Environment.create(:testing, []))
  #   Puppet.push_context({:loaders => loaders}, "test-examples")
  # end
  #
  # after(:all) do
  #   Puppet::Pops::Loaders.clear
  #   Puppet::pop_context()
  # end
  #
  # def breakpoint(*args)
  #   Puppet.lookup(:loaders).puppet_system_loader.load(:function, 'debug::break').call({}, *args)
  # end
  #
  # let(:type_parser) { Puppet::Pops::Types::TypeParser.new }
  #
  # it 'should raise an Error if there is less than 1 arguments' do
  #   expect { breakpoint() }.to raise_error(/expects 1 arguments, got 0/)
  # end
  #
  # it 'should raise an Error if there is more than 2 arguments' do
  #   expect { breakpoint('a,b','foo', 'bar') }.to raise_error(/expects 1 arguments, got 3/)
  # end
  #
  # it "should call Puppet::Util::Package.versioncmp (included in scope)" do
  #   expect(breakpoint('value')).to eq('something')
  # end

end
