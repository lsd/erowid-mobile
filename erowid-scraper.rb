require 'nokogiri'
require 'restclient'
require 'ostruct'

class ErowidScraper
  attr_reader :url

  class NoSuchPsychoactive < RuntimeError; end

  def initialize(slug)
    @base_struct = self.class.common_psychoactives[slug]
    raise NoSuchPsychoactive unless @base_struct

    @url = 'http://www.erowid.org' + @base_struct.path
    puts "Scraping #{@url}"
    @page = Nokogiri::HTML(RestClient.get(@url))
  rescue RestClient::ResourceNotFound
    raise "Erowid page not found, #{@url} must be wrong"
  end

  def name
    @page.css('div.ts-substance-name')[0].text
  end

  def common_names
    @page.css('div.sum-common-name')[0].text
  end

  def effects
    @page.css('div.sum-effects')[0].text
  end

  def chemical_name
    @page.css('div.sum-chem-name')[0].text rescue nil
  end

  def description
    @page.css('div.sum-description')[0].text
  end

  def image_path
    @page.css('div.summary-card-topic-image img')[0]['src']
  end

  def image_url
    @url.gsub(/[^\/]+$/, '') + image_path
  end

  def self.common_psychoactives
    {
      'alcohol' => OpenStruct.new(:name => 'Alcohol', :slug => 'alcohol', :path => '/chemicals/alcohol/alcohol.shtml'),
      'amanitas' => OpenStruct.new(:name => 'Amanitas', :slug => 'amanitas', :path => '/plants/amanitas/amanitas.shtml'),
      'amt' => OpenStruct.new(:name => 'AMT', :slug => 'amt', :path => '/chemicals/amt/amt.shtml'),
      'ayahuasca' => OpenStruct.new(:name => 'Ayahuasca', :slug => 'ayahuasca', :path => '/chemicals/ayahuasca/ayahuasca.shtml'),
      'cacti' => OpenStruct.new(:name => 'Cacti', :slug => 'cacti', :path => '/plants/cacti/cacti.shtml'),
      'caffeine' => OpenStruct.new(:name => 'Caffeine', :slug => 'caffeine', :path => '/chemicals/caffeine/caffeine.shtml'),
      'cannabis' => OpenStruct.new(:name => 'Cannabis', :slug => 'cannabis', :path => '/plants/cannabis/cannabis.shtml'),
      'cocaine' => OpenStruct.new(:name => 'Cocaine', :slug => 'cocaine', :path => '/chemicals/cocaine/cocaine.shtml'),
      'datura' => OpenStruct.new(:name => 'Datura', :slug => 'datura', :path => '/plants/datura/datura.shtml'),
      'dmt' => OpenStruct.new(:name => 'DMT', :slug => 'dmt', :path => '/chemicals/dmt/dmt.shtml'),
      'dxm' => OpenStruct.new(:name => 'DXM', :slug => 'dxm', :path => '/chemicals/dxm/dxm.shtml'),
      'ghb' => OpenStruct.new(:name => 'GHB', :slug => 'ghb', :path => '/chemicals/ghb/ghb.shtml'),
      'heroin' => OpenStruct.new(:name => 'Heroin', :slug => 'heroin', :path => '/chemicals/heroin/heroin.shtml'),
      'inhalants' => OpenStruct.new(:name => 'Inhalants', :slug => 'inhalants', :path => '/chemicals/inhalants/inhalants.shtml'),
      'kava' => OpenStruct.new(:name => 'Kava', :slug => 'kava', :path => '/plants/kava/kava.shtml'),
      'ketamine' => OpenStruct.new(:name => 'Ketamine', :slug => 'ketamine', :path => '/chemicals/ketamine/ketamine.shtml'),
      'lsd' => OpenStruct.new(:name => 'LSD', :slug => 'lsd', :path => '/chemicals/lsd/lsd.shtml'),
      'maois' => OpenStruct.new(:name => 'MAOIs', :slug => 'maois', :path => '/chemicals/maois/maois.shtml'),
      'mdma' => OpenStruct.new(:name => 'MDMA (Ecstasy)', :slug => 'mdma', :path => '/chemicals/mdma/mdma.shtml' ),
      'mescaline' => OpenStruct.new(:name => 'Mescaline', :slug => 'mescaline', :path => '/chemicals/mescaline/mescaline.shtml'),
      'meth' => OpenStruct.new(:name => 'Meth', :slug => 'meth', :path => '/chemicals/meth/meth.shtml'),
      'morning-glory' => OpenStruct.new(:name => 'Morning Glory', :slug => 'morning-glory', :path => '/plants/morning_glory/morning_glory.shtml'),
      'mushrooms' => OpenStruct.new(:name => 'Mushrooms', :slug => 'mushrooms', :path => '/plants/mushrooms/mushrooms.shtml'),
      'nitrous' => OpenStruct.new(:name => 'Nitrous', :slug => 'nitrous', :path => '/chemicals/nitrous/nitrous.shtml'),
      'nutmeg' => OpenStruct.new(:name => 'Nutmeg', :slug => 'nutmeg', :path => '/plants/nutmeg/nutmeg.shtml'),
      'opiates' => OpenStruct.new(:name => 'Opiates', :slug => 'opiates', :path => '/chemicals/opiates/opiates.shtml'),
      'peyote' => OpenStruct.new(:name => 'Peyote', :slug => 'peyote', :path => '/plants/peyote/peyote.shtml'),
      'salvia' => OpenStruct.new(:name => 'Salvia', :slug => 'salvia', :path => '/plants/salvia/salvia.shtml'),
      'spice-products' => OpenStruct.new(:name => 'Spice Products', :slug => 'spice-products', :path => '/plants/spice_product/spice_product.shtml'),
      'tobacco' => OpenStruct.new(:name => 'Tobacco', :slug => 'tobacco', :path => '/plants/tobacco/tobacco.shtml'),
      '2c-b' => OpenStruct.new(:name => '2C-B', :slug => '2c-b', :path => '/chemicals/2cb/2cb.shtml'),
      '5-meo-dmt' => OpenStruct.new(:name => '5-MeO-DMT', :slug => '5-meo-dmt', :path => '/chemicals/5meo_dmt/5meo_dmt.shtml')
    }
  end
end
