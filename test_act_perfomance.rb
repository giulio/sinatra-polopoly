require_relative 'content-api'

@article_json = <<-ARTICLE
{
  "contentData": {
    "_type": "com.atex.standard.article.ArticleBean",
    "title": "Hipster Ipsum",
    "body": "Butcher mumblecore cred sriracha, four dollar toast chambray fashion axe deep v Godard direct trade selfies Pinterest. Godard quinoa drinking vinegar, fanny pack health goth biodiesel Wes Anderson deep v locavore. Hashtag sriracha hoodie synth McSweeney's scenester, fap yr jean shorts chambray beard. Meggings lomo DIY scenester Etsy, keffiyeh pop-up. Mlkshk disrupt authentic, chillwave plaid cliche wayfarers. Normcore lumbersexual iPhone, Carles art party salvia Austin mlkshk bitters Shoreditch fixie sustainable gluten-free semiotics.",
    "lead": "Retro cardigan tousled twee, DIY cornhole before they sold out keffiyeh hoodie fap scenester pop-up Carles cray chambray."
  }
}
ARTICLE

arr=[]
t1 = Time.now

@contentApi = ContentApi.new.auth

100.times do |i|
  arr[i] = Thread.new {
    begin
      @contentApi.get("18.98", "onecms")
      ["1.121", "1.114", "1.186", "1.184", "1.163", "1.121", "1.114", "1.186", "1.184", "1.163"].each {|cid| @contentApi.get(cid) }
      @contentApi.create(@article_json)
    rescue Exception => e
      puts "#{i}\t#{e.message}"
    end
  }
end
arr.each {|t| t.join }

puts "elapsed: #{(Time.now - t1) * 1000.0}"
