require 'spec_helper'

describe Rolify::Role do
  let(:resource) { Forum.first }
  let(:user)     { User.first }

  subject { user }

  it { expect { subject.add_scope_role(:admin, Forum) }.to raise_error InstanceResourceError }
  it { expect { subject.add_scope_role(:admin, resource) }.to_not raise_error }

  context 'persisted way' do
    let(:resource) { Forum.first }
    let(:user)     { User.first }

    before { subject.add_scope_role(:admin, resource) }

    it { expect { subject.add_scope_role(:admin, resource) }.to_not raise_error }
    it { should have_role :admin, resource }
  end

  context 'new record way' do
    let(:resource) { Forum.new name: 'forum 2' }
    let(:user)     { User.new login: 'john' }

    before { subject.add_scope_role(:whatever, resource) }

    it { should have_role :whatever, resource }

    context 'remove' do
      before { subject.remove_scope_role(:whatever, resource) }
      it { should_not have_role :whatever, resource }
    end
  end

end

