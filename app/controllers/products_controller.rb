class ProductsController < ApplicationController
  before_action :set_parents, only: [:index,:new, :create, :edit, :update, :show]
  before_action :set_finds, only: [:destroy, :edit, :update, :show]
  before_action :category_parent_array, only: [:edit]
  before_action :show_all_instance, only: [:edit]

  def index
    @parents = Category.where(ancestry: nil)
    @products = Product.all
  end

  def new
    @images = Image.new
    @product = Product.new
    @product.images.build()
    @product.build_category
    @product.build_brand
  end


  def create
      @product = Product.new(product_params)
      @product.user_id = current_user.id
    if @product.save
      # params[:images][:image].each do |image|
      #   @product.images.create(image: image, product_id: @product.id)
      # end
      redirect_to root_path
    else
      render "new"
    end
  end


  def destroy
    if @product.destroy
      redirect_to root_path,notice: '削除できました'
    else
      redirect_to root_path,notice: '削除できませんでした'
    end
  end

  def edit
    @images_first = Image.where(product_id: params[:id]).first
    @images = Image.where(product_id: params[:id])
    @product.images
  end

  def update
    if product_params[:images_attributes].nil?
      flash.now[:alert] = '【画像を１枚以上入れてください】'
      render :edit
    else
      exit_ids = []
      product_params[:images_attributes].each do |a,b|
        exit_ids << product_params[:images_attributes].dig(:"#{a}", :id).to_i
      end
      ids = Image.where(product_id: params[:id]).map{|image| image.id}
      delete_db = ids - exit_ids
      Image.where(id: delete_db).destroy_all
      @product.touch

      if @product.update(product_params)
        redirect_to root_path, notice: '更新されました'
      else
        flash.now[:alert] = '更新できませんでした'
        render action: :edit
      end
    end
  end

  def search
    respond_to do |format|
      format.html
      format.json do
        if params[:parent_id]
          @childrens = Category.find(params[:parent_id]).children
        elsif params[:child_id]
          @grandchildren = Category.find("#{params[:child_id]}").children
        end
      end
    end
  end


  def show
    @images = Image.where(product_id: params[:id])
    # @image = Image.find(params[:id])

    @category_id = @product.category_id                            
    @category_parent = Category.find(@category_id).parent.parent                    
    @category_child = Category.find(@category_id).parent
    @category_grandchild = Category.find(@category_id)
  end


  def set_parents
    @parents = Category.where(ancestry: nil)
  end

  def set_finds
    @product = Product.find(params[:id])
  end
  
  def set_builds
    @product.build_category
    @product.build_brand
  end

private

  def product_params
    params.require(:product).permit(:name, :description_of_item, :price,:category_id ,:commodity_condition , :shipping_charges, :days_until_shipping , :prefecture_id,
    brand_attributes: [:id, :name],images_attributes: [:id, :product_id, :image])
  end

  def category_parent_array
    @category_parent_array = Category.where(ancestry: nil).each do |parent|
    end
  end

 

  def show_all_instance
    @category_id = @product.category_id
    @category_parent = Category.find(@category_id).parent.parent
    @category_child = Category.find(@category_id).parent
    @category_grandchild = Category.find(@category_id)
  end

end
