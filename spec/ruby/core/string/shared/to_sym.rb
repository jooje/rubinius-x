describe :string_to_sym, :shared => true do
  it "returns the symbol corresponding to self" do
    "Koala".send(@method).should == :Koala
    'cat'.send(@method).should == :cat
    '@cat'.send(@method).should == :@cat
    'cat and dog'.send(@method).should == :"cat and dog"
    "abc=".send(@method).should == :abc=
  end

  it "does not special case +(binary) and -(binary)" do
    "+(binary)".send(@method).should == :"+(binary)"
    "-(binary)".send(@method).should == :"-(binary)"
  end

  ruby_version_is ""..."1.9" do
    it "special cases !@ and ~@" do
      "!@".send(@method).should == :"!"
      "~@".send(@method).should == :~
    end

    it "special cases !(unary) and ~(unary)" do
      "!(unary)".send(@method).should == :"!"
      "~(unary)".send(@method).should == :~
    end

    it "special cases +(unary) and -(unary)" do
      "+(unary)".send(@method).should == :"+@"
      "-(unary)".send(@method).should == :"-@"
    end

    it "raises an ArgumentError when self can't be converted to symbol" do
      lambda { "".send(@method)           }.should raise_error(ArgumentError)
      lambda { "foo\x00bar".send(@method) }.should raise_error(ArgumentError)
    end
  end

  ruby_version_is "1.9" do
    it "does not special case certain operators" do
      [ ["!@", :"!@"],
        ["~@", :"~@"],
        ["!(unary)", :"!(unary)"],
        ["~(unary)", :"~(unary)"],
        ["+(unary)", :"+(unary)"],
        ["-(unary)", :"-(unary)"]
      ].should be_computed_by(@method)
    end
  end
end
