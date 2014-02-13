# coding: UTF-8

# Persona:  Pius
# Job:      Inventory Pool Manager
#

module Persona

  class Pius

    @@name = "Pius"
    @@lastname = Faker::Name.last_name
    @@email = "pius@zhdk.ch"
    @@inventory_pool_name = "A-Ausleihe"

    def initialize
      setup_dependencies

      ActiveRecord::Base.transaction do
        create_lending_manager_user
        create_external_user
        create_user_with_large_hand_over
        create_users_with_take_backs
      end
    end

    def setup_dependencies 
      Persona.create :mike
    end

    def create_lending_manager_user
      @language = Language.find_by_locale_name "de-CH"
      @user = FactoryGirl.create(:user, :language => @language, :firstname => @@name, :lastname => @@lastname, :login => @@name.downcase, :email => @@email)
      @inventory_pool = InventoryPool.find_by_name(@@inventory_pool_name)
      @user.access_rights.create(:role => :lending_manager, :inventory_pool => @inventory_pool)
    end

    def create_external_user
      @external_user = FactoryGirl.create(:user, :language => @language, :firstname => "Peter", :lastname => "Silie", :login => "peter", :email => "peter@silie.com")
      @external_user.access_rights.create(:role => :customer, :inventory_pool => @inventory_pool)
    end

    def create_user_with_large_hand_over
      user = FactoryGirl.create :user
      user.access_rights.create(:role => :customer, :inventory_pool => @inventory_pool)

      approved_contract = FactoryGirl.create(:contract, :user => user, :inventory_pool => @inventory_pool, :status => :approved)
      approved_contract_purpose = FactoryGirl.create :purpose, :description => "Ersatzstativ für die Ausstellung."

      @inventory_pool.items.borrowable.select{|i| not i.current_borrower}.take(30).each do |i|
        approved_contract.contract_lines << FactoryGirl.create(:contract_line, :purpose => approved_contract_purpose, :contract => approved_contract, :model => i.model, :item => i)
      end
    end

    def create_users_with_take_backs
      # user with a take back which has an option line with quantity >= 2
      user1 = FactoryGirl.create :user
      user1.access_rights.create(:role => :customer, :inventory_pool => @inventory_pool)

      contract = FactoryGirl.create(:contract, :user => user1, :inventory_pool => @inventory_pool, :status => :approved)
      contract_purpose = FactoryGirl.create :purpose, :description => "Ersatzstativ für die Ausstellung."

      contract.contract_lines << FactoryGirl.create(:option_line, purpose: contract_purpose, contract: contract, quantity: 2)
      item = FactoryGirl.create(:item, owner: @inventory_pool)
      contract.contract_lines << FactoryGirl.create(:contract_line, item: item, model: item.model, purpose: contract_purpose, contract: contract)
      contract.sign User.find_by_login("pius")

      # create user with more take backs with same option
      user2 = FactoryGirl.create :user
      user2.access_rights.create(:role => :customer, :inventory_pool => @inventory_pool)

      contract = FactoryGirl.create(:contract, :user => user2, :inventory_pool => @inventory_pool, :status => :approved)
      contract_purpose = FactoryGirl.create :purpose, :description => "Ersatzstativ für die Ausstellung."

      option = FactoryGirl.create :option, inventory_pool: @inventory_pool
      contract.contract_lines << FactoryGirl.create(:option_line, option: option, purpose: contract_purpose, contract: contract, quantity: 2, start_date: Date.yesterday, end_date: Date.today)
      contract.contract_lines << FactoryGirl.create(:option_line, option: option, purpose: contract_purpose, contract: contract, quantity: 1, start_date: Date.yesterday, end_date: Date.tomorrow)
      contract.sign User.find_by_login("pius")
    end

  end
end
