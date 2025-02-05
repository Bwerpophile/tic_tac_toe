# Initialize la partie
class Player
  attr_accessor :name, :team

  def initialize(name, team)
    @name = name
    @team = team
  end

  def to_s
    "Player : #{@name} is #{@team} "
  end
end

# Définit le board
class TicTacToe
  attr_accessor :board, :board_update, :winner

  def initialize
    @board = [
      %w[1 2 3],
      %w[4 5 6],
      %w[7 8 9]
    ]
    puts 'welcome to tic_tac_toe'
    @last_symbole = nil
  end

  def display_board
    @board.each { |row| puts row.join(' | ') }
  end

  def user_input
    user_input = gets
    user_input.to_i
    return unless !user_input.nil? && user_input < 10 && (1..10).include?(user_input)

    user_input
  end

  # mets à jour le board
  def board_update(user_input, symbole)
    @last_symbole = symbole
    if user_input <= 3 && @board[0][user_input - 1] != symbole
      @board[0][user_input - 1] = symbole
      true
    elsif user_input > 3 && user_input <= 6 && @board[1][user_input - 4] != symbole
      @board[1][user_input - 4] = symbole
      true
    elsif user_input >= 7 && @board[2][user_input - 7] != symbole
      @board[2][user_input - 7] = symbole
      true
    else
      puts 'Case déjà occupée ou invalide'
      false
    end
  end

  def winner?
    return true if @board.any? { |row| row.uniq.length == 1 }

    return true if @board.transpose.any? { |col| col.uniq.length == 1 }

    diagonal1 = [@board[0][0], @board[1][1], @board[2][2]]
    diagonal2 = [@board[0][2], @board[1][1], @board[2][0]]
    return true if [diagonal1, diagonal2].any? { |diag| diag.uniq.length == 1 }

    false
  end

  def draw?
    # Changement : Méthode simplifiée pour vérifier si le tableau est plein sans victoire
    @board.flatten.none? { |cell| cell =~ /\d/ }
  end
end

# Définit le déroulement d'une partie
class Game
  attr_accessor :choice, :current_player

  def initialize
    @player1 = Player.new('joris', 'X')
    @player2 = Player.new('Ordi', 'O')
    @tic_tac_toe = TicTacToe.new
    @current_player = @player1
  end

  def valid_input?(input)
    input.between?(1, 9) && @tic_tac_toe.board.flatten[input - 1].to_s =~ /\d/
  end

  def user_input
    input = gets.chomp.to_i
    return input if valid_input?(input)

    puts 'Entrée invalide, essayez encore.'
    nil # Retourne nil
  end

  def player_turn
    input = user_input # on récupère l'input de l'utilisateur
    return unless input

    valid_move = @tic_tac_toe.board_update(input, @current_player.team)

    if valid_move

      @tic_tac_toe.display_board
    else
      puts 'Recommencez, coup invalide.'
    end
  end

  def replay?
    puts 'Voulez-vous rejouer ? (y/n)'
    replay = gets.chomp.downcase
    replay == 'y'
  end

  def reset_game
    @tic_tac_toe = TicTacToe.new
    @current_player = @player2
  end

  def winner?
    if @tic_tac_toe.winner?
      puts "#{@current_player.name} gagne avec le symbole #{@current_player.team}!"
      return true
    end
    false
  end

  def start_game
    loop do
      puts "C'est au tour de #{@current_player.name} (#{@current_player.team})"
      player_turn

      if @tic_tac_toe.winner?
        puts "#{@current_player.name} gagne avec le symbole #{@current_player.team}!"
        break

      elsif @tic_tac_toe.draw?
        puts 'Match nul !'
        break
      end

      @current_player = @current_player == @player1 ? @player2 : @player1
    end

    if replay?
      reset_game
      puts 'La partie recommence...'
      start_game # recommence la partie
    else
      puts "Merci d'avoir joué !"
    end
  end
end

game = Game.new
game.start_game
