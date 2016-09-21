require 'haml'
require 'sass'
require 'rack'
require 'yaml'
require 'json'

class Application
  def call env
    case env["PATH_INFO"]
    when "/"
      html haml("template")
    when "/events"
      html haml("events")
    when "/save"
      save env["rack.input"].read
    else
      [404, {'Content-Type' => 'text/plain'}, ["Not found"]]
    end
  end

  private

  def save body
    [200, {'Content-Type' => 'application/json'}, [json]]
  end

  def html body
    [200, {'Content-Type' => 'text/html; charset=utf-8'}, [body]]
  end

  def haml tmpl
    Haml::Engine.new(File.read(tmpl + ".haml")).render Object.new, locals
  end

  def locals
    data.merge(
      'sass' => sass,
      'javascript' => File.read('script.js'),
      'json' => json
    )
  end

  def data
    YAML.load_file 'data.yaml'
  end

  def sass
    Sass::Engine.new(File.read('style.sass')).render
  end

  def json
    JSON.generate data
  end
end
