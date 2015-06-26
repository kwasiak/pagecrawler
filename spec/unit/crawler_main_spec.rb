require 'rspec'
require 'crawler/crawler_main'

describe 'CheckLinks', :unit do

  it 'Recognizes internal link as internal (not-external) in relation to the root domain (google.com)' do
    crawler = Crawler::CrawlerMain.new

    expect(crawler.instance_eval { is_link_external?('http://mail.google.com', 'google.com') }).to eq(false)
  end

  it 'Recognizes internal link as internal (not-external) in relation to the root host (www.google.com)' do
    crawler = Crawler::CrawlerMain.new

    expect(crawler.instance_eval { is_link_external?('http://mail.google.com', 'www.google.com') }).to eq(false)
  end

  it 'Recognizes external link as external' do
    crawler = Crawler::CrawlerMain.new

    expect(crawler.instance_eval { is_link_external?('http://mail.google.com', 'yahoo.com') }).to eq(true)
  end

  # this is real-life scenario found during procedure testing with www.reuters.com
  # the url of the external site contains reuters.com, so we have to take into consideration the root site,
  # not entire URL
  it 'Recognizes doubleclick links as external to www.routers.com' do
    crawler = Crawler::CrawlerMain.new
    expect(crawler.instance_eval { is_link_external?('http://ad.doubleclick.net/N4735792/jump/africa.reuters.com/home;type=Marketing;sz=1x1;taga=aaaaaaaaa;ord=8478?',
                                                     'www.reuters.com') }).to eq(true)
  end

  it 'Recognizes thompsonrouters.com as external in relation to www.reuters.com' do
    crawler = Crawler::CrawlerMain.new
    expect(crawler.instance_eval { is_link_external?('http://thompsonreuters.com/site1/site2',
                                                     'www.reuters.com') }).to eq(true)
  end

  it 'Recognizes http://ar.reuters.com/home as internal in relation to www.reuters.com' do
    crawler = Crawler::CrawlerMain.new
    expect(crawler.instance_eval { is_link_external?('http://ar.reuters.com/home',
                                                     'www.reuters.com') }).to eq(false)
  end
end