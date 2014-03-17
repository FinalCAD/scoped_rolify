require 'spec_helper'

describe Rolify::Finders do
  let(:resource) { Forum.where(name: 'forum 1').first }
  let(:admin)    { User.where(login: 'admin').first }

  before { admin.add_role(:admin, resource) }

  it { expect { User.with_scoped_role(:admin, Forum) }.to raise_error InstanceResourceError }
  it { expect { User.with_scoped_role(:admin, resource) }.to_not raise_error }

  context 'regular way' do
    it { User.with_scoped_role(:admin, resource).should eq([admin]) }
  end

  context '#with_any_scoped_role' do
    let(:moderator) { User.where(login: 'moderator').first }
    before { moderator.add_role(:moderator, resource) }
    it do
      expect(User.with_any_scoped_role([:admin, :moderator], resource)).to be_a(ActiveRecord::Relation)
    end
    it do
      expect(User.with_any_scoped_role([:admin, :moderator], resource).to_a).to eq([admin, moderator])
    end
  end

  context 'with root resource' do
    let(:root_resource)    { Category.where(name: 'category 1').first }
    let(:another_resource) { Forum.where(name: 'forum 2').first }
    let(:super_admin)      { User.where(login: 'super admin').first }
    let(:moderator)        { User.where(login: 'moderator').first }

    before do
      root_resource.forums << resource
      root_resource.forums << another_resource
    end

    context 'add role to user' do
      before do
        super_admin.add_scope_role(:super_admin, resource)
        moderator.add_scope_role(:super_admin, another_resource)
      end

      it('should retreive super_admin') { expect(User.with_scoped_role(:super_admin, resource).to_a).to eq([super_admin]) }
      it('should retreive all user for Category') { expect(User.with_scoped_role(:super_admin, root_resource, true).to_a).to eq([super_admin, moderator]) }
    end
  end
end

