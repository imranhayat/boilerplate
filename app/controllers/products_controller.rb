# frozen_string_literal: true

# :Product Controller for handling products actions:
class ProductsController < ApplicationController
  load_and_authorize_resource
  def show; 
    add_breadcrumb 'Admin Panel', admin_panel_path,
                   title: 'Back to the Admin Panel'
    add_breadcrumb 'Product'
  end

  def new
    @product = Product.new
    add_breadcrumb 'Admin Panel', admin_panel_path,
                   title: 'Back to the Admin Panel'
    add_breadcrumb 'Add New Product'
  end

  # POST /products
  def create
    response = Products::CreateProduct.call(product_params: product_params)
    if response.success?
      redirect_to new_plan_path, notice: 'Product was successfully created.'
    else
      redirect_to new_product_path, alert: "Product Error: #{response.message}"
    end
  end

  private

  # Only allow a trusted parameter "white list" through.
  def product_params
    params.require(:product).permit(:name, :payment_gateway)
  end
end
