# MathsTest.pm (C) 1998 Richard Foley -> richard@rfitech.com
# For Catherine and Jennifer :-) 
package MathsQuestion;

=head1 NAME

MathsQuestion - Supplier of simple maths questions to Question or Quiz.

=cut

use Question;
use strict;
use vars qw (@ISA);
@ISA = qw(Question);
srand;

=head1 SYNOPSIS

	use MathsQuestion;
	use Quiz;
	use strict;
	my @list;
	my @qs = qw(add subtract multiply divide); 
	foreach (@qs) {
		my ($qst, $ans) = MathsQuestion->new($_, 1);
		push (@list, $qst, $ans);
	}
	my $quiz = Quiz->new(@list);
	$quiz->prompt('Question: '); #going to use our own prompt.
	while ($quiz->unanswered_questions) {
		print $quiz->next_question, "\n"; 
		$_ = <>;
		if ($quiz->check_guess($_)) {
			print $quiz->{right_message};
		} else {
			print $quiz->{wrong_message};
		}
	}
	$quiz->finished;
	print $quiz->results;
	exit;
	

=cut

=item new

	Create new object:
	
	my $m = MathsQuestion->new($func, $level); 
	
	#$level is either 1, 2 or 3, default is 1.
	
	#add, subtract, multiply, divide
	#? or a, s, m, d 
	#? or + - x / %(o)
	
	my $mx = MathsQuestion->new('m');

=cut

sub new {
    my $class = shift;
    my ($func, $level) = @_;
    #my $self = Question->new;
    my $self = $class->SUPER::new(1,1); 
  	#$self->match_operator('numeric');
	$level = 1 unless defined $level;   # set default
	$self->difficulty($level);          # or whatever
    $self->$func();
    return $self;
    #? return ($self->question, $self->answer);
}

    
# ADD
sub add {
	my $self = shift;
	$self->{symbol} = "+";
    my ($a, $b) = (0, 0);
    $a = int(rand $self->_range) + 1;
    $b = int(rand $self->_range) + 1;
    $self->answer($a + $b);
    $self->question("$a $self->{symbol} $b");
    $self;
}

# MULTIPLY
sub multiply {
	my $self = shift;
	$self->{symbol} = "x";
    my ($a, $b) = (0, 0);
    $a = int(rand $self->_range) + 1;
    $b = int(rand $self->_range) + 1;
    $self->answer($a * $b);
    $self->question("$a $self->{symbol} $b");
    $self;
}

# SUBTRACT
sub subtract {
	my $self = shift;
	$self->{symbol} = "-";
    my ($a, $b) = (0, 0);
    $a = int(rand $self->_range) + 1;
    $b = int(rand $self->_range) + 1;
    $self->answer($a - $b);
    $self->question("$a $self->{symbol} $b");
    $self;
}

# DIVIDE
sub divide {
	my $self = shift;
	$self->{symbol} = "/";
    my ($a, $b, $c) = (0, 0, 0);
    $b = int(rand $self->_range) + 1;
	$c = int(rand $self->_range) + 1;
    $a = ($b * $c);
    $self->answer($c);
    $self->question("$a $self->{symbol} $b");
    $self;
}

sub difficulty {
	my $self = shift;
	$self->{difficulty} = $_[0] if @_;
	return $self->{difficulty};
}

#private

# RANGE
sub _range {
	my $self = shift;
    my $range = 1;
    $range = ($self->{difficulty} * 10) if $self->difficulty == 1;
    $range = ($self->{difficulty} * 100) if $self->difficulty == 2;
    $range = ($self->{difficulty} * 1000) if $self->difficulty == 3;
    $range = ($self->{difficulty} * 10000 * $self->{difficulty}) 
    	if $self->{difficulty} > 3; #just in case :-).
    return $self->{range} = $range;
}

1;

