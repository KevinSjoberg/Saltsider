require 'json'

class Saltsider
  RANKS = ['Script Kid', 'n00b', 'Programmer', 'Rock Star', 'l33t',
    'Saltsider']

  P_ATTRIBUTES = [:name, :email, :phone]
  S_ATTRIBUTES = [:html, :css, :javascript, :ruby, :ruby_on_rails]

  def initialize(attributes = {})
    @attributes = normalize_attributes(attributes)
  end

  def profile
    Hash[P_ATTRIBUTES.map { |a| [a, @attributes[a]] }]
  end

  def skills
    Hash[S_ATTRIBUTES.map { |a| [a, @attributes[a]] }]
  end

  def valid?
    ((P_ATTRIBUTES + S_ATTRIBUTES) - @attributes.keys).empty?
  end

  def to_json
    JSON.dump(saltsider: profile.merge(skills: skills))
  end

  def level_of_awesomeness
    RANKS[skills.values.count(true)]
  end

  private

  def normalize_attributes(attributes)
    Hash[attributes.map { |k, v| [k.to_s.gsub('knows_', '').to_sym, v] }]
  end
end

describe Saltsider do
  before do
    @saltsider = Saltsider.new(:name => "Saltsider",
                               :email => "hello@saltside.se",
                               :phone => "+46704676919",
                               :knows_html => true,
                               :knows_css => true,
                               :knows_javascript => true,
                               :knows_ruby => true,
                               :knows_ruby_on_rails => true)

    @json = '{"saltsider":{"name":"Saltsider","email":"hello@saltside.se","phone":"+46704676919","skills":{"html":true,"css":true,"javascript":true,"ruby":true,"ruby_on_rails":true}}}'
  end

  context "measurement of awesomeness :D" do
    it "should rank 5 skill points as Saltsider" do
      saltsider = Saltsider.new(:knows_html => true, :knows_css => true, :knows_javascript => true,
                                :knows_ruby => true, :knows_ruby_on_rails => true)
      saltsider.level_of_awesomeness.should eq "Saltsider"
    end

    it "should rank 4 skill points as l33t" do
      saltsider = Saltsider.new(:knows_html => true, :knows_css => true,
                                :knows_ruby => true, :knows_ruby_on_rails=> true)
      saltsider.level_of_awesomeness.should eq "l33t"
    end

    it "should rank 3 skill points as Rock Star" do
      saltsider = Saltsider.new(:knows_html => true, :knows_css => true,
                                :knows_ruby_on_rails => true)
      saltsider.level_of_awesomeness.should eq "Rock Star"
    end

    it "should rank 2 skill points as Programmer" do
      saltsider = Saltsider.new(:knows_html => true, :knows_ruby_on_rails => true)
     saltsider.level_of_awesomeness.should eq "Programmer"
    end

    it "should rank 1 skill points as n00b" do
      saltsider = Saltsider.new(:knows_html => true)
      saltsider.level_of_awesomeness.should eq "n00b"
    end

    it "should rank 0 skill points as Script Kid" do
      saltsider = Saltsider.new()
      saltsider.level_of_awesomeness.should eq "Script Kid"
    end
  end

  it "should return data in json format" do
    @saltsider.to_json.should eq @json
  end

  it "should validate presence of name" do
    saltsider = Saltsider.new(:email => "hello@saltside.se",
                              :phone => "+46704676919",
                              :knows_html => true,
                              :knows_css => true,
                              :knows_javascript => true,
                              :knows_ruby => true,
                              :knows_ruby_on_rails => true)
    saltsider.valid?.should eq false
  end

  it "should validate presence of email" do
    saltsider = Saltsider.new(:name => "Saltsider",
                              :phone => "+46704676919",
                              :knows_html => true,
                              :knows_css => true,
                              :knows_javascript => true,
                              :knows_ruby => true,
                              :knows_ruby_on_rails => true)
    saltsider.valid?.should eq false
  end

  it "should validate presence of phone number" do
    saltsider = Saltsider.new(:name => "Saltsider",
                              :email => "hello@saltside.se",
                              :knows_html => true,
                              :knows_css => true,
                              :knows_javascript => true,
                              :knows_ruby => true,
                              :knows_ruby_on_rails => true)
    saltsider.valid?.should eq false
  end

  it "should validate presence of skills" do
    saltsider = Saltsider.new(:name => "Saltsider",
                              :email => "hello@saltside.se",
                              :phone => "+46704676919",
                              :knows_html => true,
                              :knows_css => true,
                              :knows_javascript => true,
                              :knows_ruby_on_rails => true)
   saltsider.valid?.should eq false
  end

  it "should validate true when all application data is valid" do
    @saltsider.valid?.should eq true
  end
end
