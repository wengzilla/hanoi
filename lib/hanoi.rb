class Hanoi
  attr_accessor :current_state, :last_moved_index, :steps

  def initialize(n)
    @current_state = [(1..n).to_a, [], []]
    @steps = 0
  end

  def solve
    move until solved?
    puts "It took #{steps} steps to solve the Hanoi problem."
  end

  def move
    move_ring_if_valid(*generate_random_move)
  end

  def generate_random_move
    [0,1,2].sample(2)
  end

  def move_ring_if_valid(start_index, end_index)
    return false unless valid_move?(start_index, end_index)

    move_ring(start_index, end_index)
  end

  def move_ring(start_index, end_index)
    current_state[end_index].unshift(current_state[start_index].shift)
    after_move_processing(end_index)
  end

  def after_move_processing(end_index)
    @steps += 1
    @last_moved_index = end_index
    puts current_state.inspect
  end

  def valid_move?(start_index, end_index)
    top_rings[start_index] && (last_moved_index != start_index || stacked?) &&
      (top_rings[end_index].nil? || top_rings[start_index] < top_rings[end_index])
  end

  def stacked?
    top_rings.compact == [1]
  end

  def top_rings
    current_state.map(&:first)
  end

  def solved?
    top_rings == [nil, nil, 1]
  end
end