class Argumentation < ApplicationRecord
  include PgSearch
  belongs_to :argument, inverse_of: :argumentation
  has_many :arguments, foreign_key: :parent_argumentation_id, inverse_of: :parent_argumentation

  pg_search_scope :tasty_search, :associated_against => {
      :argumentation => [:title, :description],
      :argument => [:title, :description]
  }


  pg_search_scope :searchfor, :against => [:title, :description], :using => {
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
