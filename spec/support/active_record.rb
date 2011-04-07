require 'active_record'
require 'sqlite3'
require 'logger'
require 'rspec/rails/adapters'
require 'rspec/rails/fixture_support'

ROOT = File.join(File.dirname(__FILE__), '..')

ActiveRecord::Base.logger = Logger.new('tmp/ar_debug.log')
ActiveRecord::Base.configurations = YAML::load(IO.read('spec/support/database.yml'))
ActiveRecord::Base.establish_connection('development')

ActiveRecord::Schema.define :version => 0 do
  create_table :ducks, :force => true do |t|
    t.string :name
    t.integer :row
    t.integer :size
    t.integer :age
    t.string :pond
  end

  create_table :rabbits, :force => true do |t|
    t.string :name
  end

  create_table :photos, :force => true do |t|
    t.string :title
    t.integer :position
    t.integer :photoable_id
    t.string :photoable_type
  end

  create_table :wrong_scope_ducks, :force => true do |t|
    t.string :name
    t.integer :size
    t.string :pond
  end

  create_table :wrong_field_ducks, :force => true do |t|
    t.string :name
    t.integer :age
    t.string :pond
  end
end

class Rabbit < ActiveRecord::Base
  
  has_many :photos, :as => :photoable, :dependent => :destroy, :order => :position  
  
end

class Duck < ActiveRecord::Base
  
  has_many :photos, :as => :photoable, :dependent => :destroy, :order => :position
  
  include RankedModel
  ranks :row
  ranks :size, :scope => :in_shin_pond
  ranks :age, :with_same => :pond

  scope :in_shin_pond, where(:pond => 'Shin')

end

class Photo < ActiveRecord::Base
  
  belongs_to :photoable, :polymorphic => true
  
  include RankedModel
  ranks :position, :with_same => :photoable_id, :and_same => :photoable_type
  
end

# Negative examples

class WrongScopeDuck < ActiveRecord::Base

  include RankedModel
  ranks :size, :scope => :non_existant_scope

end

class WrongFieldDuck < ActiveRecord::Base

  include RankedModel
  ranks :age, :with_same => :non_existant_field

end
