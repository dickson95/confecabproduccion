class RolesUser < ApplicationRecord
  belongs_to :rol
  belongs_to :user
end
