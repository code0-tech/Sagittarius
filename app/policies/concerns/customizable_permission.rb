# frozen_string_literal: true

module CustomizablePermission
  extend ActiveSupport::Concern

  class_methods do
    attr_reader :namespace_resolver_block

    def namespace_resolver(&block)
      @namespace_resolver_block = block
    end

    def customizable_permission(ability)
      condition(ability) { user_has_ability?(ability, @user, @subject) }

      rule { send(ability) | admin }.enable ability
    end
  end

  included do
    condition(:admin) { user_has_ability?(:namespace_administrator, @user, @subject) }

    def namespace(subject)
      @namespace ||= self.class.namespace_resolver_block.call(subject)
    end

    def namespace_member(user, subject)
      @namespace_member ||= namespace(subject).namespace_members.find_by(user: user)
    end

    def user_has_ability?(ability, user, subject)
      return false if namespace_member(user, subject).nil?

      namespace_member(user, subject)
        .roles
        .joins(:abilities)
        .exists?(namespace_role_abilities: { ability: ability })
    end
  end
end
