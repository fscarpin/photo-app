class ImagesController < ApplicationController
  helper_method :sort_column, :sort_direction

  before_action :validate_payment
  before_action :set_image, only: [:show, :edit, :update, :destroy]

  # GET /images
  def index
    @images_uploaded = Image.where(user: current_user).paginate(:page => params[:page]).order(order_by)
    @image = Image.new
  end

  # GET /images/1
  def show
  end

  # POST /images
  def create
    pictures = params[:image][:pictures]

    @errors_hash = Hash.new
    pictures.each do |picture|
      file_name = picture.original_filename
      @image = Image.new(picture: picture, file_name: file_name, user_id: current_user.id)
      if !@image.save
        @errors_hash[picture.original_filename] = @image.errors.full_messages.first
      end
    end

    if @errors_hash.empty?
      flash[:notice] = "Uploaded Successfully"
      redirect_to images_path
    else
      @images_uploaded = Image.where(user: current_user).paginate(:page => params[:page]).order(order_by)
      @image = Image.new
      render :index
    end
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

  def order_by
    column = (sort_column == "file_name") ? "LOWER(#{sort_column})" : sort_column

    "#{column} #{sort_direction}"
  end

  def sort_column
    # If the session doesn't have the sort_column information, let's set it to "created_at"
    session[:sort_column] = "created_at" if session[:sort_column].blank?

    # If the user wants to sort using another column, let's set this preference in the session
    if Image.column_names.include? (params[:sort])
      session[:sort_column] = params[:sort]
    end

    session[:sort_column]
  end

  def sort_direction
    # If the session doesn't have the sort_direction info, let's set it to "desc"
    session[:sort_direction] = "desc" if session[:sort_direction].blank?

    # If the user wants to change the sort dicrection, let's set this in the session
    if ["asc", "desc"].include?(params[:direction])
      session[:sort_direction] = params[:direction]
    end

    session[:sort_direction]
  end
end
