# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RuntimeParameterDefinition do
  subject { create(:runtime_parameter_definition) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:runtime_name) }

    it {
      is_expected.to validate_uniqueness_of(:runtime_name).case_insensitive.scoped_to(:runtime_function_definition_id)
    }

    it { is_expected.to validate_length_of(:runtime_name).is_at_most(50) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:runtime_function_definition) }
    it { is_expected.to belong_to(:data_type) }
  end
end
