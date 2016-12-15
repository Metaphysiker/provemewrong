class Argumentation < ApplicationRecord
  belongs_to :argument, inverse_of: :argumentation
  has_many :arguments, foreign_key: :parent_argumentation_id, inverse_of: :parent_argumentation
end
