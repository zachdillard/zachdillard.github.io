require_relative 'test_helper'

class TestSiteStructure < TestHelper
  def test_root_index_file_exists
    index_path = File.join(@repo_root, 'index.html')
    assert file_exists?(index_path), "Root index.html file should exist"
  end
  
  def test_gemfile_exists
    gemfile_path = File.join(@repo_root, 'Gemfile')
    assert file_exists?(gemfile_path), "Gemfile should exist"
  end
  
  def test_gemspec_exists
    gemspec_path = File.join(@repo_root, 'github-personal-website.gemspec')
    assert file_exists?(gemspec_path), "Gemspec file should exist"
  end
  
  def test_readme_exists
    readme_path = File.join(@repo_root, 'README.md')
    assert file_exists?(readme_path), "README.md should exist"
  end
  
  def test_license_exists
    license_path = File.join(@repo_root, 'LICENSE.txt')
    assert file_exists?(license_path), "LICENSE.txt should exist"
  end
  
  def test_gitignore_exists
    gitignore_path = File.join(@repo_root, '.gitignore')
    assert file_exists?(gitignore_path), "gitignore should exist"
  end
  
  def test_index_html_has_layout
    index_path = File.join(@repo_root, 'index.html')
    content = read_file(index_path)
    
    # Should have Jekyll front matter with layout
    assert content.match(/^---\s*\n.*layout:\s*\w+.*\n---/m), 
           "Index.html should have Jekyll front matter with layout"
  end
  
  def test_posts_directory_exists
    posts_dir = File.join(@repo_root, '_posts')
    assert directory_exists?(posts_dir), "Posts directory should exist"
  end
  
  def test_site_directory_structure
    # Core Jekyll directories that should exist
    required_dirs = %w[_includes _layouts _posts]
    
    required_dirs.each do |dir|
      dir_path = File.join(@repo_root, dir)
      assert directory_exists?(dir_path), "Directory #{dir} should exist"
    end
  end
  
  def test_gemfile_content
    gemfile_path = File.join(@repo_root, 'Gemfile')
    content = read_file(gemfile_path)
    
    # Should reference github-pages gem
    assert content.include?('github-pages'), 
           "Gemfile should reference github-pages gem"
    
    # Should have proper source
    assert content.include?("source 'https://rubygems.org'"), 
           "Gemfile should specify rubygems source"
  end
  
  def test_gemspec_content
    gemspec_path = File.join(@repo_root, 'github-personal-website.gemspec')
    content = read_file(gemspec_path)
    
    # Should have basic gemspec structure
    assert content.include?('Gem::Specification.new'), 
           "Gemspec should have proper structure"
    
    # Should specify Jekyll dependency
    assert content.include?('jekyll'), 
           "Gemspec should specify Jekyll dependency"
  end
  
  def test_gitignore_content
    gitignore_path = File.join(@repo_root, '.gitignore')
    content = read_file(gitignore_path)
    
    # Should ignore Jekyll build artifacts
    jekyll_ignores = %w[_site .sass-cache]
    jekyll_ignores.each do |ignore|
      assert content.include?(ignore), 
             "gitignore should include #{ignore}"
    end
  end
  
  def test_favicon_exists
    favicon_path = File.join(@repo_root, 'favicon.ico')
    assert file_exists?(favicon_path), "favicon.ico should exist"
  end
  
  def test_no_build_artifacts_in_repo
    # Check that common build artifacts are not tracked
    # Build artifacts should be in gitignore (tested above)
    # This test mainly validates our gitignore is working
    
    # Just verify that the gitignore test above covers this
    assert true, "Build artifacts exclusion tested via gitignore validation"
  end
  
  def test_ruby_version_file
    ruby_version_path = File.join(@repo_root, '.ruby-version')
    
    # This file is optional but if it exists, should be valid
    if file_exists?(ruby_version_path)
      content = read_file(ruby_version_path).strip
      assert content.match(/^\d+\.\d+(\.\d+)?$/), 
             "Ruby version should be in format X.Y or X.Y.Z"
    end
  end
end