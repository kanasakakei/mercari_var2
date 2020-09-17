class Product < ApplicationRecord
  # アクティブハッシュ引用の記載
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture

  
  # belongs_to :buy_product
  belongs_to :category
  belongs_to :brand
  # belongs_to :exhibition_history
  belongs_to :user
  has_many :images, dependent: :destroy

  accepts_nested_attributes_for :images , allow_destroy: true
  accepts_nested_attributes_for :brand

  validates :name, :description_of_item ,:commodity_condition,
            :shipping_charges,:prefecture_id, :days_until_shipping,:price  ,presence: true
  
  validates :name, length: { maximum: 40}
  validates :description_of_item , length: { maximum: 1000}
  validates :price, numericality: {only_integer:true, greater_than:299, less_than:10000000}
  validates_associated :images
  validates :images, presence: true

end
