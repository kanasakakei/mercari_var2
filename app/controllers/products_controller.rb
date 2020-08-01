class ProductsController < ApplicationController
  before_action :set_parents, only: [:index,:new, :create]

  def index
  end

  def new
    @product = Product.new
    @product.images.new
    @product.build_category
    @product.build_brand
  end


  def create
    
      @product = Product.new(product_params)
    if @product.save
      redirect_to root_path
    else
      render action: :new
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


  def set_parents
    @parents = Category.where(ancestry: nil)
  end



private

  def product_params
    params.require(:product).permit(:name, :description_of_item, :price,:category_id ,:commodity_condition , :shipping_charges, :days_until_shipping , :prefecture_id,
    brand_attributes: [:id, :name],images_attributes: [:id,:image])
  end


end