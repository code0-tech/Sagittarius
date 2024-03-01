# frozen_string_literal: true

class TeamRoleAbility < ApplicationRecord
  ABILITIES = {
    create_team_role: { db: 1, description: 'Allows the creation of roles in a team' },
    invite_member: { db: 2, description: 'Allows to invite new members to a team' },
    assign_member_roles: { db: 3, description: 'Allows to change the roles of a team member' },
    assign_role_abilities: { db: 4, description: 'Allows to change the abilities of a team role' },
  }.with_indifferent_access

  enum :ability, ABILITIES.transform_values { |v| v[:db] }, prefix: :can

  belongs_to :team_role, inverse_of: :abilities

  validates :ability, presence: true,
                      inclusion: {
                        in: ABILITIES.keys.map(&:to_s),
                      },
                      uniqueness: { scope: :team_role_id }
end
