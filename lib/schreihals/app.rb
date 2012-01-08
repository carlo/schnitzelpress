module Schreihals
  class App < Sinatra::Base
    set :views, File.expand_path('../../views/', __FILE__)
    set :public_folder, File.expand_path('../../public/', __FILE__)

    use Schreihals::Static
    use Rack::ShowExceptions
    use Rack::Cache
    use Rack::Codehighlighter, :coderay, :markdown => true, :element => "pre>code", :pattern => /\A:::(\w+)\s*\n/

    helpers Schreihals::Helpers
    include Schreihals::Actions

    configure do
      set :blog_title, "My Schreihals Blog"
      set :blog_url, ""
      set :blog_description, ""
      set :author_name, "Author"
      set :disqus_name, nil
      set :google_analytics_id, nil
      set :gauges_id, nil
      set :read_more, "Read Complete Article"
      set :documents_store, :filesystem
      set :documents_source, './posts'
      set :documents_cache, nil
      set :twitter_id, nil
      set :footer, ""
    end

    def refresh_documents_now?
      !Post.documents.any?
    end

    def refresh_documents!
      case settings.documents_store
      when :filesystem
        Post.from_directory(settings.documents_source)
      # when :dropbox
      #   Post.send(:include, DocumentMapper::DropboxStore)
      #   Post.load_documents_from_dropbox(settings.documents_source, :cache => settings.documents_cache)
      else
        raise "Unknown documents store '#{settings.documents_store}'."
      end
    end

    def render_page(slug)
      if @post = Post.with_slug(slug)
        haml :post
      else
        halt 404
      end
    end

    def absolutionize(url)
      if should_absolutionize?(url)
        "#{base_url}#{url}"
      else
        url
      end
    end

    def should_absolutionize?(url)
      url && url[0] == '/'
    end

    def base_url
      "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}"
    end

    not_found do
      haml :"404"
    end
  end
end
