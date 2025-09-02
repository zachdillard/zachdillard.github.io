require 'minitest/autorun'
require 'yaml'
require 'fileutils'

class TestHelper < Minitest::Test
  # Helper methods for all tests
  
  def setup
    @repo_root = File.expand_path('..', __dir__)
    @config_file = File.join(@repo_root, '_config.yml')
    @includes_dir = File.join(@repo_root, '_includes')
    @layouts_dir = File.join(@repo_root, '_layouts')
    @assets_dir = File.join(@repo_root, 'assets')
  end
  
  def load_config
    YAML.load_file(@config_file)
  end
  
  def read_file(path)
    File.read(path)
  end
  
  def file_exists?(path)
    File.exist?(path)
  end
  
  def directory_exists?(path)
    Dir.exist?(path)
  end
  
  def list_files_in_directory(dir)
    Dir.glob(File.join(dir, '*')).select { |f| File.file?(f) }
  end
  
  def validate_liquid_syntax(content)
    # Basic check for matching Liquid tags
    # Extract all liquid tags
    tags = content.scan(/{%\s*([^%]+)\s*%}/).flatten
    
    # Track opening and closing tags
    tag_stack = []
    
    tags.each do |tag|
      tag = tag.strip
      
      # Skip tags that don't need closing
      next if tag.match(/^(include|assign|capture|octicon|comment)/)
      next if tag.match(/^echo\s/) # Jekyll echo tag
      
      # Handle if/unless blocks
      if tag.match(/^(if|unless)\s/)
        tag_stack.push(tag.split.first)
      elsif tag == 'else' || tag.match(/^elsif\s/)
        # else and elsif are valid in if/unless blocks, no action needed
        next
      elsif tag.match(/^end(if|unless)$/)
        expected = tag[3..-1] # Remove 'end' prefix
        if tag_stack.empty? || tag_stack.last != expected
          return [false, "Unmatched closing tag: #{tag}"]
        end
        tag_stack.pop
        
      # Handle for loops
      elsif tag.match(/^for\s/)
        tag_stack.push('for')
      elsif tag == 'endfor'
        if tag_stack.empty? || tag_stack.last != 'for'
          return [false, "Unmatched endfor tag"]
        end
        tag_stack.pop
        
      # Handle case statements
      elsif tag == 'case'
        tag_stack.push('case')
      elsif tag.match(/^when\s/)
        # when is valid in case blocks
        next
      elsif tag == 'endcase'
        if tag_stack.empty? || tag_stack.last != 'case'
          return [false, "Unmatched endcase tag"]
        end
        tag_stack.pop
      end
    end
    
    # Check if all tags are properly closed
    unless tag_stack.empty?
      return [false, "Unclosed tags: #{tag_stack.join(', ')}"]
    end
    
    [true, nil]
  end
end