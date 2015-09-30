class Photo < ActiveRecord::Base
  validates :url, presence: true, uniqueness: true

  def heart_count
    self.hearts.count
  end
end
