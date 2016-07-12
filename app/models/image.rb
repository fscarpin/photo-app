class Image < ActiveRecord::Base

  belongs_to :user
  mount_uploader :picture, PictureUploader
  validate :picture_max_size

  private
  def picture_max_size
    if self.picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5Mb")
    end
  end
end
