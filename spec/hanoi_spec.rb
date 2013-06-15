require 'spec_helper'

describe Hanoi do
  before(:each) do
    @h = Hanoi.new(3)
  end

  context "#new" do
    it "initializes current state to have n rings on the first peg" do
      @h.current_state.should eq [[1,2,3],[],[]]
    end

    it "initializes steps to zero" do
      @h.steps.should eq 0
    end
  end

  context "#solve" do
    before(:each) { @h.stub(:puts) }

    it "calls move until the puzzle is solved" do
      @h.stub(:solved?).and_return(false, false, true)
      @h.should_receive(:move).twice
      @h.solve
    end
  end

  context "#move" do
    it "calls generate_random_move and move_ring" do
      @h.should_receive(:generate_random_move).once.and_return([1,2])
      @h.should_receive(:move_ring_if_valid).once.with(1,2)
      @h.move
    end
  end

  context "#move_ring_if_valid" do
    context "given an invalid move" do
      it "leaves the current_state unmodified" do
        @h.should_receive(:valid_move?).once.with(1,2).and_return(false)
        @h.should_receive(:move_ring).never
        @h.move_ring_if_valid(1,2).should eq nil
      end
    end

    context "given a valid move" do
      it "calls move_ring" do
        @h.should_receive(:valid_move?).once.with(1,2).and_return(true)
        @h.should_receive(:move_ring).once.with(1,2)
        @h.move_ring_if_valid(1,2)
      end
    end
  end

  context "#move_ring" do
    before(:each) { @h.stub(:after_move_processing) }

    it "moves a ring from a starting index to an ending index" do
      @h.current_state = [[2],[3],[1]]
      @h.move_ring(0,1)
      @h.current_state.should eq [[],[2,3],[1]]
    end

    it "calls after_move_processing" do
      @h.should_receive(:after_move_processing).once.with(1)
      @h.move_ring(0,1)
    end
  end

  context "#after_move_processing" do
    before(:each) { @h.stub(:puts) }

    it "increments the steps" do
      lambda{ @h.after_move_processing(1) }.should change(@h, :steps).by(1)
    end

    it "sets the last_moved_index" do
      @h.after_move_processing(1)
      @h.last_moved_index.should eq 1
    end
  end

  context "#generate_random_move" do
    it "returns an array representing a move from start peg to end peg" do
      @h.generate_random_move.size.should eq 2
      @h.generate_random_move.class.should eq Array
    end
  end

  context "#solved?" do
    context "given the problem has not been solved" do
      it "returns false" do
        @h.solved?.should eq false
        @h.current_state = [[],[1,2,3],[]]
        @h.solved?.should eq false
      end
    end

    context "given the problem has been solved" do
      it "returns true" do
        @h.current_state = [[],[],[1,2,3]]
        @h.solved?.should eq true
      end
    end
  end

  context "#top_rings" do
    it "returns an array representing the top rings in the current state" do
      @h.current_state = [[],[1,2,3],[]]
      @h.top_rings.should eq [nil, 1, nil]

      @h.current_state = [[],[1],[2,3]]
      @h.top_rings.should eq [nil, 1, 2]
    end
  end

  context "#stacked?" do
    it "returns a boolean representing whether or not all the rings are stacked" do
      @h.current_state = [[],[1,2,3],[]]
      @h.stacked?.should eq true

      @h.current_state = [[],[1],[2,3]]
      @h.stacked?.should eq false
    end
  end
end