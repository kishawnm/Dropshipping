class Vendor < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_many :vendor_disputes, dependent: :destroy
  has_many :automated_responses, dependent: :destroy
  has_many :response_presets, dependent: :destroy
  has_many :vendor_pages, dependent: :destroy
end
