require 'spec_helper'

describe Duck do

  before {
    @ducks = {
      :quacky => Duck.create(
        :name => 'Quacky',
        :pond => 'Shin' ),
      :feathers => Duck.create(
        :name => 'Feathers',
        :pond => 'Shin' )
    }
    
    @rabbits = {
      :peter => Rabbit.create(
        :name => 'Peter'),
      :eliott => Rabbit.create(
        :name => 'Eliott')
    }
    
    @ducks.each do |name, duck|
      Photo.create(:title => "#{name}_photo1", :photoable => duck)
      Photo.create(:title => "#{name}_photo2", :photoable => duck)
    end

    @rabbits.each do |name, rabbit|
      Photo.create(:title => "#{name}_photo1", :photoable => rabbit)
      Photo.create(:title => "#{name}_photo2", :photoable => rabbit)
    end

    
  }
  
  describe "adding a photo" do

    before {
      @ducks[:quacky].photos.first.update_attribute :position, 1
      @ducks[:quacky].photos.last.update_attribute :position, 2
      @last_photo = Photo.create(:title => "quacky_photo3", :photoable => @ducks[:quacky])
    }
    
    subject { @ducks[:quacky].photos.rank(:position).all }
    
    its(:size) { should == 3 }
    its(:last) { should == @last_photo }
    
  end

  describe "" do
    
  end

end
