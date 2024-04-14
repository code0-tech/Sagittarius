# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::OrganizationRoles::Update do
  it { expect(described_class.graphql_name).to eq('OrganizationRolesUpdate') }
end
