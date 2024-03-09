# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Organizations::Create do
  it { expect(described_class.graphql_name).to eq('OrganizationsCreate') }
end
