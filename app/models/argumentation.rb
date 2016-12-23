class Argumentation < ApplicationRecord

  attr_accessor :info, :infomain

  include PgSearch

  belongs_to :argument, inverse_of: :argumentation
  has_many :arguments, foreign_key: :parent_argumentation_id, inverse_of: :parent_argumentation

  def self.get_search_attributes_from_argumentation
    [:title, :description]
  end

  attributes = get_search_attributes_from_argumentation
  pg_search_scope :searchfor, :against => attributes, :using => {
      :tsearch => {:prefix => true}
  }

  pg_search_scope :like,
                  :against => :description,
                  :using => {
                      :trigram => {
                          :threshold => 0.1
                      }
                  }


end
