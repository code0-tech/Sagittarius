# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TeamMember do
  subject { create(:team_member) }

  describe 'associations' do
    it { is_expected.to belong_to(:team).required }
    it { is_expected.to belong_to(:user).required }
    it { is_expected.to have_many(:member_roles).class_name('TeamMemberRole').inverse_of(:member) }
    it { is_expected.to have_many(:roles).class_name('TeamRole').through(:member_roles).inverse_of(:members) }
  end

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:team).scoped_to(:user_id) }
  end
end
