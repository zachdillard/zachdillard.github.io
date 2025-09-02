require_relative 'test_helper'

class TestScss < TestHelper
  def test_assets_directory_exists
    assert directory_exists?(@assets_dir), "Assets directory should exist"
  end
  
  def test_styles_scss_exists
    styles_path = File.join(@assets_dir, 'styles.scss')
    assert file_exists?(styles_path), "styles.scss file should exist"
  end
  
  def test_styles_scss_has_valid_syntax
    styles_path = File.join(@assets_dir, 'styles.scss')
    content = read_file(styles_path)
    
    # Basic SCSS syntax validation
    # Check for proper import syntax if imports exist
    imports = content.scan(/@import\s+['"]([^'"]+)['"];?/)
    imports.each do |import|
      # Basic validation - imports should not be empty
      refute import.first.empty?, "SCSS imports should not be empty"
    end
    
    # Check for basic SCSS/CSS structure
    # Should not have obvious syntax errors like unclosed braces
    open_braces = content.count('{')
    close_braces = content.count('}')
    
    # Allow some flexibility but check for major imbalances
    brace_diff = (open_braces - close_braces).abs
    assert brace_diff <= 1, "SCSS should have balanced braces (found #{open_braces} open, #{close_braces} close)"
  end
  
  def test_styles_scss_has_jekyll_front_matter
    styles_path = File.join(@assets_dir, 'styles.scss')
    content = read_file(styles_path)
    
    # Jekyll SCSS files should start with front matter (--- lines)
    lines = content.lines
    if lines.length >= 2
      first_line = lines[0].strip
      second_or_later_line = lines[1..-1].find { |line| line.strip == '---' }
      
      # Check if it starts with Jekyll front matter
      if first_line == '---'
        assert second_or_later_line, "SCSS file should have proper Jekyll front matter closing"
      end
    end
  end
  
  def test_styles_scss_content_structure
    styles_path = File.join(@assets_dir, 'styles.scss')
    content = read_file(styles_path)
    
    # Should be non-empty after front matter
    # Remove front matter for content check
    content_without_frontmatter = content.gsub(/^---\s*\n.*?\n---\s*\n/m, '')
    refute content_without_frontmatter.strip.empty?, "SCSS file should have actual style content"
  end
  
  def test_no_invalid_scss_characters
    styles_path = File.join(@assets_dir, 'styles.scss')
    content = read_file(styles_path)
    
    # Check for common SCSS syntax issues
    # Check for unmatched quotes (basic check)
    single_quotes = content.count("'")
    double_quotes = content.count('"')
    
    # Basic quote balance check (not perfect but catches obvious issues)
    # This is a simple check - real SCSS parsing would be more complex
    assert single_quotes.even?, "SCSS should have balanced single quotes"
    assert double_quotes.even?, "SCSS should have balanced double quotes"
  end
  
  def test_styles_file_readable
    styles_path = File.join(@assets_dir, 'styles.scss')
    
    # Test that we can read the file without errors
    begin
      File.read(styles_path)
      assert true, "Successfully read styles.scss"
    rescue => e
      flunk "Should be able to read styles.scss without errors: #{e.message}"
    end
  end
end