# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['NamespaceMemberRole'] do
  let(:fields) do
    %w[
      id
      member
      role
      createdAt
      updatedAt
    ]
  end

  it { expect(described_class.graphql_name).to eq('NamespaceMemberRole') }
  it { expect(described_class).to have_graphql_fields(fields) }
  it { expect(described_class).to require_graphql_authorizations(:read_namespace_member_role) }
end
