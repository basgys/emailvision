# encoding: utf-8
require 'spec_helper'

describe Emailvision::Relation do

  subject { described_class.new(api, :get) }

  let(:api) { allow(double("api")).to receive(:call) }

  context "#initialize" do

    [:get, :post].each do |verb|

      it "initializes relation with HTTP verb #{verb}" do
        expect { described_class.new(api, verb) }.to_not raise_error
      end

    end

  end

  context "chaining" do

    it "returns a relation" do
      expect(subject.get).to be_a(described_class)
    end

    it "chains multiple methods and returns a relation" do
      expect(subject.get.member).to be_a(described_class)
    end    

  end

  context "#call" do

    it "triggers a call" do
      expect(api).to receive(:call).with(:get, 'get/member/getMemberByEmail', {:uri=>["basgys@gmail.com"]})
      subject.get.member.get_member_by_email(uri: ['basgys@gmail.com']).call
    end

  end

end