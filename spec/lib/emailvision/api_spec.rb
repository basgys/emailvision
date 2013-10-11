# encoding: utf-8
require 'spec_helper'

describe Emailvision::Api do

  subject do 
    described_class.new(
      server_name: 'emvapi.emv3.com',
      login: 'api_login',
      password: 'api_password',
      key: 'api_key',
      endpoint: 'apimember'
    )
  end

  it "opens connection successfuly" do
    VCR.use_cassette('opens connection successfuly') do
      subject.open_connection
      expect(subject.connected?).to be(true)
    end
  end

  it "closes connection successfuly" do
    VCR.use_cassette('closes connection successfuly') do
      subject.token = '111token111'
      expect(subject.close_connection).to eq("connection closed")
      expect(subject.connected?).to be(false)
    end
  end

  it "invalidates token properly" do
    subject.token = '111token111'
    expect(subject.invalidate_token!).to eq(nil)
    expect(subject.connected?).to be(false)
  end

  it "deconnects when the endpoint is changed" do
    subject.token = '111token111'
    VCR.use_cassette('deconnects when the endpoint is changed') do
      subject.endpoint = 'apiccmd'
      expect(subject.connected?).to be(false)
    end
  end

  it "returns base_uri" do
    expect(subject.base_uri).to eq("http://#{subject.server_name}/#{subject.endpoint}/services/rest/")
  end

  context 'Relation' do

    let(:relation) { Emailvision::Relation }

    before do
      Emailvision::Relation.stub(new: relation)
    end    

    [:get, :post].each do |verb|

      it "returns a relation when #{verb} is called" do
        expect(relation).to receive(:new).with(subject, verb)
        expect(subject.send(verb)).to be_a(relation.class)
      end

    end

  end

  context 'Member' do

    it "retrieves member by email successfuly" do
      VCR.use_cassette('retrieves member by email successfuly') do
        subject.token = '111token111'
        result = subject.get.member.get_member_by_email(uri: ['basgys@gmail.com']).call
        expect(result).to eq({
          "members"=>{
            "member"=>{
              "attributes"=>{
                "entry"=>[
                  {"key"=>"MEMBER_ID", "value"=>"1"}, 
                  {"key"=>"EMAIL", "value"=>"basgys@gmail.com"}, 
                  {"key"=>"ANOTHER_FIELD", "value"=>"another value"}
                ]
              }
            }
          }, 
          "responseStatus"=>"success"
        })
      end
    end

    it "retrieves member by id successfuly" do
      VCR.use_cassette('retrieves member by id successfuly') do
        subject.token = '111token111'
        result = subject.get.member.get_member_by_id(id: 1).call
        expect(result).to eq({
          "members"=>{
            "member"=>{
              "attributes"=>{
                "entry"=>[
                  {"key"=>"MEMBER_ID", "value"=>"1"}, 
                  {"key"=>"EMAIL", "value"=>"basgys@gmail.com"}, 
                  {"key"=>"ANOTHER_FIELD", "value"=>"another value"}
                ]
              }
            }
          }, 
          "responseStatus"=>"success"
        })
      end 
    end

    it "cannot find a member with this email" do
      VCR.use_cassette('cannot find a member with this email') do
        subject.token = '111token111'
        result = subject.get.member.get_member_by_email(uri: ['fake@ema.il']).call
        expect(result).to eq({"members"=>nil, "responseStatus"=>"success"})
      end
    end

  end

end