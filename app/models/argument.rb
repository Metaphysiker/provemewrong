class Argument < ApplicationRecord
  has_one :argumentation, inverse_of: :argument
  belongs_to :parent_argumentation, class_name: 'Argumentation', inverse_of: :arguments

  def self.get_search_attributes_from_argument
    [:title, :description]
  end


  def add_place
    argumentation = Argumentation.find(self.parent_argumentation_id)
    place_number = argumentation.arguments.maximum("place")
    if place_number == 0
      self.update(place: 1)
    else
      place_number = place_number + 1
      self.update(place: place_number)
    end
  end


  include PgSearch
  attributes = get_search_attributes_from_argument
  pg_search_scope :searchfor, :against => attributes, :using => {
      :tsearch => {:prefix => true}
  }

end
