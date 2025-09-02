require_relative 'test_helper'

class TestTemplates < TestHelper
  def test_includes_directory_exists
    assert directory_exists?(@includes_dir), "Includes directory should exist"
  end
  
  def test_layouts_directory_exists
    assert directory_exists?(@layouts_dir), "Layouts directory should exist"
  end
  
  def test_required_includes_exist
    required_includes = %w[
      footer.html
      header.html
      interests.html
      masthead.html
      post-card.html
      projects.html
      repo-card.html
      thoughts.html
      topic-card.html
    ]
    
    required_includes.each do |include_file|
      include_path = File.join(@includes_dir, include_file)
      assert file_exists?(include_path), "Include file #{include_file} should exist"
    end
  end
  
  def test_required_layouts_exist
    required_layouts = %w[
      default.html
      home.html
      post.html
    ]
    
    required_layouts.each do |layout_file|
      layout_path = File.join(@layouts_dir, layout_file)
      assert file_exists?(layout_path), "Layout file #{layout_file} should exist"
    end
  end
  
  def test_includes_have_valid_liquid_syntax
    include_files = list_files_in_directory(@includes_dir)
    
    include_files.each do |include_file|
      content = read_file(include_file)
      is_valid, error_msg = validate_liquid_syntax(content)
      
      assert is_valid, "Include file #{File.basename(include_file)} has invalid Liquid syntax: #{error_msg}"
    end
  end
  
  def test_layouts_have_valid_liquid_syntax
    layout_files = list_files_in_directory(@layouts_dir)
    
    layout_files.each do |layout_file|
      content = read_file(layout_file)
      is_valid, error_msg = validate_liquid_syntax(content)
      
      assert is_valid, "Layout file #{File.basename(layout_file)} has invalid Liquid syntax: #{error_msg}"
    end
  end
  
  def test_masthead_include_structure
    masthead_path = File.join(@includes_dir, 'masthead.html')
    content = read_file(masthead_path)
    
    # Test for required elements in masthead
    assert content.include?('user.avatar_url'), "Masthead should reference user.avatar_url"
    assert content.include?('user.name'), "Masthead should reference user.name"
    assert content.include?('user.bio'), "Masthead should reference user.bio"
    assert content.include?('site.style'), "Masthead should check site.style"
    assert content.include?('site.layout'), "Masthead should check site.layout"
  end
  
  def test_projects_include_structure
    projects_path = File.join(@includes_dir, 'projects.html')
    content = read_file(projects_path)
    
    # Test for required elements in projects
    assert content.include?('site.github.public_repositories'), 
           "Projects should reference site.github.public_repositories"
    assert content.include?('repo-card.html'), 
           "Projects should include repo-card.html"
    assert content.include?('repository'), 
           "Projects should iterate over repositories"
  end
  
  def test_interests_include_structure
    interests_path = File.join(@includes_dir, 'interests.html')
    content = read_file(interests_path)
    
    # Test for required elements in interests
    assert content.include?('site.topics'), 
           "Interests should reference site.topics"
    assert content.include?('topic-card.html'), 
           "Interests should include topic-card.html"
  end
  
  def test_default_layout_structure
    default_path = File.join(@layouts_dir, 'default.html')
    content = read_file(default_path)
    
    # Test for required elements in default layout
    assert content.include?('{% include header.html %}'), 
           "Default layout should include header"
    assert content.include?('{% include footer.html %}'), 
           "Default layout should include footer"
    assert content.include?('{{ content }}'), 
           "Default layout should include content placeholder"
    assert content.include?('{% include masthead.html'), 
           "Default layout should include masthead"
  end
  
  def test_home_layout_exists_and_valid
    home_path = File.join(@layouts_dir, 'home.html')
    assert file_exists?(home_path), "Home layout should exist"
    
    content = read_file(home_path)
    is_valid, error_msg = validate_liquid_syntax(content)
    assert is_valid, "Home layout has invalid Liquid syntax: #{error_msg}"
  end
  
  def test_post_layout_exists_and_valid
    post_path = File.join(@layouts_dir, 'post.html')
    assert file_exists?(post_path), "Post layout should exist"
    
    content = read_file(post_path)
    is_valid, error_msg = validate_liquid_syntax(content)
    assert is_valid, "Post layout has invalid Liquid syntax: #{error_msg}"
  end
end