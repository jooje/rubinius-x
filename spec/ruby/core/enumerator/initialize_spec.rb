# -*- encoding: us-ascii -*-

require File.expand_path('../../../spec_helper', __FILE__)

describe "Enumerator#initialize" do
  before(:each) do
    @uninitialized = enumerator_class.allocate
  end

  it "is a private method" do
    enumerator_class.should have_private_instance_method(:initialize, false)
  end

  it "returns self when given an object" do
    @uninitialized.send(:initialize, Object.new).should equal(@uninitialized)
  end

  ruby_version_is "1.9" do
    it "returns self when given a block" do
      @uninitialized.send(:initialize) {}.should equal(@uninitialized)
    end
  end

  ruby_version_is "1.9.1" do
    # Maybe spec should be broken up?
    it "accepts a block" do
      @uninitialized.send(:initialize) do |yielder|
        r = yielder.yield 3
        yielder << r << 2 << 1
      end
      @uninitialized.should be_an_instance_of(enumerator_class)
      r = []
      @uninitialized.each{|x| r << x; x * 2}
      r.should == [3, 6, 2, 1]
    end

    ruby_version_is "" ... "2.0" do
      it "ignores block if arg given" do
        @uninitialized.send(:initialize, [1,2,3]){|y| y.yield 4}
        @uninitialized.to_a.should == [1,2,3]
      end
    end

    ruby_version_is "2.0" do
      it "sets size to nil if size is not given" do
        @uninitialized.send(:initialize) {}.size.should be_nil
      end

      it "sets size to nil if the given size is nil" do
        @uninitialized.send(:initialize, nil) {}.size.should be_nil
      end

      it "sets size to the given size if the given size is Float::INFINITY" do
        @uninitialized.send(:initialize, Float::INFINITY) {}.size.should equal(Float::INFINITY)
      end

      it "sets size to the given size if the given size is a Fixnum" do
        @uninitialized.send(:initialize, 100) {}.size.should == 100
      end

      it "sets size to the given size if the given size is a Proc" do
        @uninitialized.send(:initialize, lambda { 200 }) {}.size.should == 200
      end
    end

    describe "on frozen instance" do
      ruby_version_is "2.1" do
        it "raises a RuntimeError" do
          lambda {
            @uninitialized.freeze.send(:initialize) {}
          }.should raise_error(RuntimeError)
        end
      end
    end
  end
end
