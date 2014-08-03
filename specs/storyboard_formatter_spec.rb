$:.unshift File.expand_path('../../lib', __FILE__)

require 'bacon'
require 'ovaltine'

describe 'StoryboardFormatter' do

  it 'writes valid output paths' do
    storyboard = Ovaltine::Storyboard.new('Main?P', [])
    formatter  = Ovaltine::StoryboardFormatter.new(storyboard, '', '.')
    names = formatter.output_paths.map {|p| File.basename(p)}
    names.should.include 'Main_PStoryboard.m'
    names.should.include 'Main_PStoryboard.h'
  end

  it 'uses the prefix in output paths' do
    storyboard = Ovaltine::Storyboard.new('Main_iPhone', [])
    formatter  = Ovaltine::StoryboardFormatter.new(storyboard, 'ABC', '.')
    names = formatter.output_paths.map {|p| File.basename(p)}
    names.should.include 'ABCMain_iPhoneStoryboard.m'
    names.should.include 'ABCMain_iPhoneStoryboard.h'
  end

  it 'uses the prefix in the generated class name' do
    storyboard = Ovaltine::Storyboard.new('Onboarding', [])
    formatter  = Ovaltine::StoryboardFormatter.new(storyboard, 'DMU', '.')
    formatter.classname.should.equal 'DMUOnboardingStoryboard'
  end
end