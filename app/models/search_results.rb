class SearchResults < ActiveRecord::Base
  self.primary_key = 'argumentation_id'


  include PgSearch

  pg_search_scope :searchfor, :against => [:argumentation_title, :argumentation_description], :using => {
      :tsearch => {:prefix => true}
  }

end