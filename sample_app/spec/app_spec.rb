require 'rubygems'
require 'spec'
require 'curb'

def base_url
  'http://localhost:9900'
end

describe 'GET' do
  
  it 'should do normal get' do
    res = Curl::Easy.perform(base_url + '/')
    res.body_str.should == "Hello Universe"
    res.header_str.should include('200')
  end
  
  it 'should render a haml template' do
    res = Curl::Easy.perform(base_url + '/haml')
    res.body_str.should include('<div id="date">')
    res.body_str.should include('<div id="name">Name: Jean-Luc Picard</div>')
    res.body_str.should include('<div id="title">Title: Captain of the USS Enterprise</div>')
    res.header_str.should include('200')
  end
  
  it 'should render json' do
    res = Curl::Easy.perform(base_url + '/json')
    res.body_str.should include("[{\"command_1\":\"Make it so\"},{\"command_2\":\"You have the bridge, Number One\"}]")
    res.header_str.should include('application/json')
    res.header_str.should include('200')
  end
  
  it 'should follow redirects' do
    res = Curl::Easy.perform(base_url + '/redirect')
    res.header_str.should include('302')
    
    res = Curl::Easy.perform(base_url + '/redirect') do |opt|
      opt.follow_location = true
    end
    res.header_str.should include('200')
    res.body_str.should include('Name: Jean-Luc Picard')
  end
  
end

describe 'POST' do
  
  it 'should do normal post' do
    res = Curl::Easy.http_post(base_url + '/order')
    res.body_str.should eql("Tea, Earl Grey, Hot")
    res.header_str.should include('200')
  end
  
  it 'should accept parameters' do
    res = Curl::Easy.http_post(base_url + '/with_params', 'foo=bar&baz=bat')
    res.body_str.should eql('<h1>bar bat</h1>')
    res.header_str.should include('200')
  end
  
end

describe 'PUT' do
  
  it 'should do normal put' do
    res = Curl::Easy.http_post(base_url + '/weapon/3', '_method=put')
    res.body_str.should eql('<p>Phaser with id #3 set to stun</p>')
    res.header_str.should include('200')
  end
  
end

describe 'DELETE' do
  
  it 'should do normal delete' do
    res = Curl::Easy.http_post(base_url + '/fire/3', '_method=delete')
    res.body_str.should eql('<p>Borg cube destroyed using 3 photon torpedoes</p>')
    res.header_str.should include('200')
  end
  
  it 'should execute any logic in the callback' do
    res = Curl::Easy.http_post(base_url + '/fire/13', '_method=delete')
    res.body_str.should eql('<h1>Maximum yield, full spread!</h1>')
  end
  
end