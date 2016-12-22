class SearchResults < ActiveRecord::Base
  self.primary_key = 'argument_id'


  include PgSearch

  pg_search_scope :searchfor, :against => [:argument_title, :argument_description], :using => {
      :tsearch => {:prefix => true}
  }

end