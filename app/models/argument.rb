class Argument < ApplicationRecord
  has_one :argumentation, inverse_of: :argument
  belongs_to :parent_argumentation, class_name: 'Argumentation', inverse_of: :arguments

  include PgSearch
  pg_search_scope :searchfor, :against => [:title, :description], :using => {
      :tsearch => {:prefix => true}
  }

end
