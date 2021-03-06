

class Series
  include ActionView::Helpers

   attr_accessor :title, :synopsis, :gn_id, :show_image, :date, :genre, :seasons, :type, :contributor, :fulldesc

   def initialize(series)
     self.title = series['TITLE']
     self.fulldesc = series['SYNOPSIS']
     self.show_image = series['URL']
     self.gn_id = series['GN_ID']
     self.date = series['DATE']
     self.genre = [series['GENRE']]
     self.seasons = series['SEASON']
     self.type = series['PRODUCTION_TYPE']
     self.contributor = series['CONTRIBUTOR']
     seasonstotal
     genreparse
     contributorparse
     datefix
     truncated
     assignimage

   end

   def assignimage
     if self.show_image == nil
       self.show_image = "/images/searchImageTV.jpg"
     end
   end

  def truncated
    if self.fulldesc
      self.synopsis = truncate(self.fulldesc, length: 200, :escape => false)
    end
  end

   def datefix
     if (self.date && self.date.length > 4)
       self.date = DateTime.parse(self.date).strftime("%B %e, %Y")
     end
   end

   def seasonstotal
     if self.seasons
       self.seasons = self.seasons.length
     end
   end

   def genreparse
     if self.genre
       self.genre = self.genre.join(", ")
     end
   end

   def contributorparse
     if (self.contributor && self.contributor.class == Hash)
      self.contributor = contributor["NAME"]
    elsif (self.contributor && self.contributor.class == Array)
      self.contributor = contributor.map{|x| x["NAME"]}.join(", ")
     end

   end


end
