require_relative 'test_helper'

class TestConfig < TestHelper
  def test_config_file_exists
    assert file_exists?(@config_file), "Configuration file _config.yml should exist"
  end
  
  def test_config_file_has_valid_yaml
    config = load_config
    assert_instance_of Hash, config, "Configuration should be valid YAML"
  end
  
  def test_config_has_required_fields
    config = load_config
    
    # Test for basic Jekyll configuration
    assert config.key?('layout'), "Configuration should specify layout"
    assert config.key?('style'), "Configuration should specify style"
    assert config.key?('plugins'), "Configuration should specify plugins"
    
    # Test layout values
    assert %w[sidebar stacked].include?(config['layout']), 
           "Layout should be either 'sidebar' or 'stacked'"
    
    # Test style values  
    assert %w[light dark].include?(config['style']),
           "Style should be either 'light' or 'dark'"
  end
  
  def test_config_plugins_are_valid
    config = load_config
    plugins = config['plugins']
    
    assert_instance_of Array, plugins, "Plugins should be an array"
    
    expected_plugins = ['jekyll-octicons', 'jekyll-github-metadata']
    expected_plugins.each do |plugin|
      assert plugins.include?(plugin), "Plugin #{plugin} should be included"
    end
  end
  
  def test_config_topics_structure
    config = load_config
    topics = config['topics']
    
    assert_instance_of Array, topics, "Topics should be an array"
    assert topics.length > 0, "Should have at least one topic"
    
    topics.each do |topic|
      assert_instance_of Hash, topic, "Each topic should be a hash"
      assert topic.key?('name'), "Each topic should have a name"
      assert_instance_of String, topic['name'], "Topic name should be a string"
      
      # Optional fields validation
      if topic.key?('web_url')
        assert_instance_of String, topic['web_url'], "web_url should be a string"
        assert topic['web_url'].start_with?('http'), "web_url should be a valid URL"
      end
      
      if topic.key?('image_url')
        assert_instance_of String, topic['image_url'], "image_url should be a string"
        assert topic['image_url'].start_with?('http'), "image_url should be a valid URL"
      end
    end
  end
  
  def test_config_permalink_format
    config = load_config
    
    if config.key?('permalink')
      permalink = config['permalink']
      assert_instance_of String, permalink, "Permalink should be a string"
      assert permalink.include?(':year'), "Permalink should include :year"
      assert permalink.include?(':month'), "Permalink should include :month"
      assert permalink.include?(':day'), "Permalink should include :day"
      assert permalink.include?(':title'), "Permalink should include :title"
    end
  end
  
  def test_config_defaults_structure
    config = load_config
    
    if config.key?('defaults')
      defaults = config['defaults']
      assert_instance_of Array, defaults, "Defaults should be an array"
      
      defaults.each do |default|
        assert_instance_of Hash, default, "Each default should be a hash"
        assert default.key?('scope'), "Each default should have a scope"
        assert default.key?('values'), "Each default should have values"
        
        scope = default['scope']
        assert_instance_of Hash, scope, "Scope should be a hash"
        
        values = default['values']
        assert_instance_of Hash, values, "Values should be a hash"
      end
    end
  end
end