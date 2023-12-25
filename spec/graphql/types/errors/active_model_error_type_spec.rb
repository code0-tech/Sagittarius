# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['ActiveModelError'] do
  let(:fields) do
    %w[
      attribute
      type
    ]
  end

  it { expect(described_class.graphql_name).to eq('ActiveModelError') }
  it { expect(described_class).to have_graphql_fields(fields) }
end
