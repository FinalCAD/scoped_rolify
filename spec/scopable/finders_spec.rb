require 'spec_helper'

describe Rolify::Finders do
  let(:resource) { Forum.first }
  let(:user) { User.first }

  before { user.add_role(:admin, resource) }

  subject { User }

  it { expect { subject.with_role(:admin) }.to raise_error MissingResourceError }
  it { expect { subject.with_role(:admin, Forum) }.to raise_error InstanceResourceError }
  it { expect { subject.with_role(:admin, resource) }.to_not raise_error }

  context 'regular way' do
    it { User.with_role(:admin, resource).should eq([user]) }
  end

end

