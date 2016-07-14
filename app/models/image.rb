class Image < ActiveRecord::Base
  belongs_to :user
  mount_uploader :picture, PictureUploader

  validates :picture, presence: true
  validates :file_name, presence: true
  validate :picture_max_size

  def file_name
    self.picture.file.filename
  end

  private
  def picture_max_size
    if self.picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5Mb")
    end
  end
end
