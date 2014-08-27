$:.unshift File.expand_path('../../lib', __FILE__)

require 'bacon'
require 'ovaltine/storyboard'
require 'ovaltine/objc/storyboard_formatter'

describe 'StoryboardFormatter' do

  it 'writes valid output paths' do
    storyboard = Ovaltine::Storyboard.new('Main?P', [])
    formatter  = Ovaltine::StoryboardFormatter.new(storyboard, '', '', '.')
    names = formatter.output_paths.map {|p| File.basename(p)}
    names.should.include 'Main_PStoryboard.m'
    names.should.include 'Main_PStoryboard.h'
  end

  it 'uses the prefix in output paths' do
    storyboard = Ovaltine::Storyboard.new('Main_iPhone', [])
    formatter  = Ovaltine::StoryboardFormatter.new(storyboard, 'ABC', '', '.')
    names = formatter.output_paths.map {|p| File.basename(p)}
    names.should.include 'ABCMain_iPhoneStoryboard.m'
    names.should.include 'ABCMain_iPhoneStoryboard.h'
  end

  it 'uses the prefix in the generated class name' do
    storyboard = Ovaltine::Storyboard.new('Onboarding', [])
    formatter  = Ovaltine::StoryboardFormatter.new(storyboard, 'DMU', '', '.')
    formatter.classname.should.equal 'DMUOnboardingStoryboard'
  end

  it 'uses the current year in copyright text' do
    storyboard = Ovaltine::Storyboard.new('GameOver', [])
    formatter  = Ovaltine::StoryboardFormatter.new(storyboard, 'DMU', 'Kattrali Inc.', '.')
    formatter.copyright_text.should.include "Copyright (c) #{Time.new.year}"
  end

  it 'uses the given copyright owner' do
    storyboard = Ovaltine::Storyboard.new('GameOver', [])
    formatter  = Ovaltine::StoryboardFormatter.new(storyboard, 'DMU', 'Kattrali Inc.', '.')
    formatter.copyright_text.should.include 'Kattrali Inc.'
  end

  it 'opens copyright information when not provided' do
    storyboard = Ovaltine::Storyboard.new('GameOver', [])
    formatter  = Ovaltine::StoryboardFormatter.new(storyboard, 'DMU', '', '.')
    formatter.copyright_text.downcase.should.not.include "Copyright"
  end
end