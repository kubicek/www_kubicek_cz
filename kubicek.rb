require "rubygems"
require "sinatra"
require "lib/post"
require "lib/category"
require "rdiscount"

get "/kdo-jsem/?" do
  erb :about
end

get "/temata/?" do
  @categories = Category.all
  erb :categories
end

get "/temata/:category_id" do
  @posts = Marley::Post.find_all_by_category(params[:category_id])
  throw :halt, [404, not_found ] unless @posts
  erb :posts
end

get "/clanky/:post_id.html" do
  @post = Marley::Post[params[:post_id]]
  throw :halt, [404, not_found ] unless @post
  @post=Marley::Post.new(Marley::Post.extract_post_info_from(@post))
  erb :post
end

get "/galerie/?" do
  erb :gallery
end

get "/kontakt/?" do
  erb :contact
end

get "/?" do
  @posts = Marley::Post.find_all
  erb :posts
end