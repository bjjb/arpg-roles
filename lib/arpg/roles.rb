require 'arpg/roles/version'
require 'active_support/concern'

module ARPG
  module Roles
    extend ActiveSupport::Concern
    class_methods do
      def roles(*roles, on: :roles)
        klass = (class << self; self; end)

        roles.each do |role|
          klass.send(:define_method, role) do
            where("'#{role}' = ANY(#{on})")
          end

          define_method(:"#{role}?") do
            send(on).include?(role.to_s)
          end
        end
      end
    end
  end
end
