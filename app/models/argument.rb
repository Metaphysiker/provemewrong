class Argument < ApplicationRecord
  has_one :argumentation, inverse_of: :argument
  belongs_to :parent_argumentation, class_name: 'Argumentation', inverse_of: :arguments
end
