require 'spec_helper'

describe Rolify::Role do
  let(:instance) { Forum.first }

  subject { User.first }

  it { expect { subject.add_scope_role(:admin, Forum) }.to raise_error InstanceResourceError }
  it { expect { subject.add_scope_role(:admin, instance) }.to_not raise_error }

  context 'regular way' do
    before { subject.add_scope_role(:admin, instance) }
    it { should have_role :admin, instance }
  end

end

