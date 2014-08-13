$:.unshift File.expand_path('../../lib', __FILE__)

require 'bacon'
require 'ovaltine'

describe 'Storyboard' do

  before do
    @path = File.expand_path('features/fixtures/Sample/Sample/Base.lproj/Main.storyboard')
    @storyboard = Ovaltine::Storyboard.new('Main', [@path])
  end

  it 'caches identifiers for generic view controllers' do
    @storyboard.view_controller_identifiers.should.include "sampleViewController"
  end

  it 'caches identifiers for collection view controllers' do
    @storyboard.view_controller_identifiers.should.include "collectionViewController"
  end

  it 'caches identifiers for table view controllers' do
    @storyboard.view_controller_identifiers.should.include "listViewController"
  end

  it 'caches identifiers for navigation view controllers' do
    @storyboard.view_controller_identifiers.should.include "navigationViewController"
  end

  it 'caches identifiers for named segues' do
    @storyboard.segue_identifiers.should.include "starterSegueIdentifier"
  end

  it 'caches cell reuse identifiers for table view cells' do
    @storyboard.cell_reuse_identifiers.should.include "sampleCellIdentifier"
  end

  it 'caches cell reuse identifiers for collection view cells' do
    @storyboard.cell_reuse_identifiers.should.include "squareCellIdentifier"
  end
end