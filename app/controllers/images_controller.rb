class ImagesController < ApplicationController
  before_action :validate_payment
  before_action :set_image, only: [:show, :edit, :update, :destroy]

  # GET /images
  # GET /images.json
  def index
    @images_uploaded = Image.where(user: current_user)

    @new_images = []
    @image = Image.new
  end

  # GET /images/1
  # GET /images/1.json
  def show
  end

  # GET /images/1/edit
  def edit
  end

  # POST /images
  # POST /images.json
  def create
    pictures = []
    if !params[:image][:picture].kind_of? Array
      pictures << params[:image][:picture]
    else
      pictures = params[:image][:picture]
    end

    errors_hash = {}
    pictures.each do |picture|
      @image = Image.new(picture: picture, user_id: current_user.id)
      if !@image.save
        errors_hash[picture.original_filename] = @image.errors.full_messages.first
      end
    end

    if errors_hash.empty?
      flash[:notice] = "Uploaded Successfully"
    else
      error_msg = ""
      errors_hash.each do |file, error|
        flash[:error] = "#{file}: #{error}"
      end
    end

    redirect_to images_path
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image.destroy
    respond_to do |format|
      format.html { redirect_to images_url, notice: 'Image was deleted successfully.' }
      format.json { head :no_content }
    end
  end

  def destroy_multiples
    image_ids = params[:image_ids]

    if !image_ids
      redirect_to images_path
      return
    end

    image_ids.each do |id|
      Image.find(id).destroy
    end

    flash[:notice] = "Images have been deleted"
    redirect_to images_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = Image.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_params
      params.require(:image).permit(:picture, :user_id)
    end

    def validate_payment
      if user_signed_in? && current_user.payment == false
        redirect_to new_charge_path
      end
    end
end
