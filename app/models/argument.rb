class Argument < ApplicationRecord
  has_one :argumentation, inverse_of: :argument
  belongs_to :parent_argumentation, class_name: 'Argumentation', inverse_of: :arguments

  def self.get_search_attributes_from_argument
    [:title, :description]
  end


  include PgSearch
  attributes = get_search_attributes_from_argument
  pg_search_scope :searchfor, :against => attributes, :using => {
      :tsearch => {:prefix => true}
  }

end
