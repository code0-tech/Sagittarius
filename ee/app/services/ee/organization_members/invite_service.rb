# frozen_string_literal: true

module EE
  module OrganizationMembers
    module InviteService
      include Sagittarius::Override

      protected

      override :validate_user_limit!
      def validate_user_limit!(t)
        license = organization.current_license
        return if license.nil? || !license.restricted?(:user_count)
        return if organization.organization_members.count <= license.restrictions[:user_count]

        t.rollback_and_return! ServiceResponse.error(
          message: 'No free member seats in license',
          payload: :no_free_license_seats
        )
      end
    end
  end
end
