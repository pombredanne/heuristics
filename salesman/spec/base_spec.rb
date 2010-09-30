require File.dirname(__FILE__) + '/spec_helper'

describe Salesman::Edge do

  describe "<=>" do
    it "should compare based on distance" do
      e_1 = Salesman::Edge.new(mock(Salesman::City), mock(Salesman::City))
      e_1.stub!(:distance => 5)
      e_2 = Salesman::Edge.new(mock(Salesman::City), mock(Salesman::City))
      e_2.stub!(:distance => 10)
      e_3 = Salesman::Edge.new(mock(Salesman::City), mock(Salesman::City))
      e_3.stub!(:distance => 5)

      (e_1 <=> e_2).should == -1
      (e_2 <=> e_1).should == 1
      (e_1 <=> e_3).should == 0
    end
  end
end

describe Salesman::SpanTree do

  describe "build" do
    it "should build array of array of tree cities n and tree edges length n - 1" do
      cities, edges = [], []
      10.times { cities << mock(Salesman::City) }
      20.times { edges << mock(Salesman::City, :a => cities[rand(10)], :b => cities[rand(10)]) }
      tree = Salesman::SpanTree.new(cities, edges)
      tree.build
      tree.tree_cities.length.should  == cities.length
      tree.tree_edges.length.should   == cities.length - 1
    end
  end
end