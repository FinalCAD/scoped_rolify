require 'spec_helper'

describe Rolify::Finders do
  let(:resource) { Forum.first }
  let(:admin)    { User.where(login: 'admin').first }

  before { admin.add_role(:admin, resource) }

  subject { User }

  it { expect { subject.with_scoped_role(:admin, Forum) }.to raise_error InstanceResourceError }
  it { expect { subject.with_scoped_role(:admin, resource) }.to_not raise_error }

  context 'regular way' do
    it { subject.with_scoped_role(:admin, resource).should eq([admin]) }
  end

  context '#with_any_scoped_role' do
    let(:moderator) { subject.where(login: 'moderator').first }
    before { moderator.add_role(:moderator, resource) }
    it do
      expect(subject.with_any_scoped_role([:admin, :moderator], resource)).to be_a(ActiveRecord::Relation)
    end
    it do
      expect(subject.with_any_scoped_role([:admin, :moderator], resource).to_a).to eq([admin, moderator])
    end
  end

  context 'with root resource' do
    let(:user)          { User.first }
    let(:root_resource) { Category.first }

    before { root_resource.forums << resource }

    context 'add role to user' do
      before { user.add_scope_role(:admin, resource) }
      it('should retreive user') { expect(User.with_scoped_role(:admin, resource).to_a).to eq([user]) }
    end
  end
end