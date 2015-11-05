require 'sinatra'
require 'haml'
require_relative '../content-api-sdks/ruby/content-api'

before do
  @contentApi = ContentApi.new.auth
end


get '/content/:c_id' do
  content = @contentApi.get(params[:c_id])
  haml :article, :locals => {
    :article => content.aspect('contentData'),
    :created => content.created_at,
    :metadata => content.aspect('atex.Metadata').metadata
  }
end

get '/' do
  results = @contentApi.search({ :q => '*', :fq => 'inputTemplate:standard.Article', :variant => 'com.atex.plugins.grid.teaserable', :sort => 'modifiedDate desc', :rows => '50'})
  haml :index, :locals => { :articles => results.aspects, :tag_line => "Recents" }
end

get '/topic/:dimension/:entity' do
  results = @contentApi.search({ :q => '*',
                :fq => "tag_dimension.#{params[:dimension]}:#{params[:entity]}",
                :variant => 'com.atex.plugins.grid.teaserable',
                :sort => 'modifiedDate desc', :rows => '50'})
  haml :index, :locals => { :articles => results.aspects, :tag_line => params[:entity] }
end


helpers do

  def url_for(contentId)
    return "/content/#{contentId.sub('contentid/','')}"
  end

  def img_url(contentId, width = 400)
    return if contentId.nil?
    return "http://localhost:8080/image/policy:#{contentId.sub('contentid/','')}/image.jpg?w=#{width}"
  end

end
