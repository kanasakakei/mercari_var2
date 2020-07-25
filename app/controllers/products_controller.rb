class ProductsController < ApplicationController
  
  def index
  end

  def new
    @product = Product.new
    @product.images.new
    @product.build_brand
    @parents = Category.all.order("id ASC").limit(13)
  end


  def create
    @products = Product.includes(:images).order('created_at DESC')
      @product = Product.new(product_params)
    if @product.save
      redirect_to root_path
    else
      render :new
    end
  end

  def search
    respond_to do |format|
      format.html
      format.json do
        @children = Category.find(params[:parent_id]).children
      end
    end
  end


private

  def product_params
    params.require(:product).permit(:name, :description_of_item, :price, :category, :commodity_condition , :shipping_charges, :days_until_shipping ,images_attributes: [:image],
    brand_attributes: [:id, :name], category_ids: [])
  end


end