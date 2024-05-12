# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganizationProjects::DeleteService do
  subject(:service_response) { described_class.new(current_user, organization_project).execute }

  let!(:organization) { create(:organization) }
  let!(:organization_project) { create(:organization_project, organization: organization) }

  context 'when user is nil' do
    let(:current_user) { nil }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { OrganizationProject.count } }

    it do
      expect { service_response }.not_to create_audit_event(:organization_project_deleted)
    end
  end

  context 'when user is not a member' do
    let(:current_user) { create(:user) }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { OrganizationProject.count } }

    it do
      expect { service_response }.not_to create_audit_event(:organization_project_deleted)
    end
  end

  context 'when user is a member' do
    let(:current_user) { create(:user) }

    before do
      create(:organization_member, organization: organization, user: current_user)
      stub_allowed_ability(OrganizationPolicy, :delete_organization_project, user: current_user,
                                                                             subject: organization)
    end

    it { is_expected.to be_success }
    it { expect(service_response.payload).to eq(organization_project) }
    it { expect { service_response }.to change { OrganizationProject.count }.by(-1) }

    it do
      expect { service_response }.to create_audit_event(
        :organization_project_deleted,
        author_id: current_user.id,
        entity_id: organization_project.id,
        entity_type: 'OrganizationProject',
        details: {
          organization_id: organization_project.organization.id,
        },
        target_id: organization_project.id,
        target_type: 'OrganizationProject'
      )
    end
  end
end
