#!/usr/bin/perl 
# Question.pm (C) 1998 Richard Foley -> richard@rfitech.com
# For Catherine and Jennifer
#
package Question;
use strict;

=head1 NAME

Question - Container for question 'n' answer.

=cut

=head1 SYNOPSIS

	Designed to be used within L<Quiz> module.

=cut


=item new

	Object creator:
	
	my $q = Question->new('2 + 2', '4');

=cut

sub new {
	my $self = {
		'question' 	=> '',
		'answer' 	=> '',
		'guess'		=> '',
		'wrong_guesses' => [],
		'status'	=> undef,
		'correct' 	=> 0,
		'wrong'		=> 0,
		'asked'		=> undef,
		'match_operator' => 'regex',
		'auto_select' => 1,
	};
	bless $self, shift; #(ref(shift) || (shift)));
	die ("No question($_[0]), or answer($_[1]) given!") unless @_ == 2; 
	$self->{question} = shift;
	$self->{answer} = shift;
	return $self;
}
#

=item question

	my $qstn = $q->question;
	
=cut

sub question {
	my $self = shift;
	$self->{question} = $_[0] if @_;
	return $self->{question};
}
#

=item answer

	my $ans = $q->answer;

=cut

sub answer {
	my $self = shift;
	$self->{answer} = $_[0] if @_;
	return $self->{answer};
}
#

=item ask

	Prompt for the question:
	
	print $q->ask('What is..: ');		

=cut

sub ask {
	my $self = shift;
	my ($prompt) = @_;
	$self->{time_started} = time; 
	$self->{asked}++;
	return $prompt.$self->{question};
}
#

=item guess

	Sets guessed time, and inputs guess into question.
	
	my $guess = $q->guess('4');

=cut

sub guess {
	my $self = shift;
	my $guess;
	if (@_) {
		($guess) = @_; chomp $guess;
		$self->{guess} = $guess;
		$self->_guessed;
	}
	return $self->{guess};
}
#

=item correct

	Returns status of answer (correct or incorrect).
	
	print "yeeha!\n" if $q->correct;

=cut

sub correct {
	my $self = shift;
	return $self->{status};
}
#

=item results

	Simple print out of stats for question.
	
	print $q->results;

=cut

sub results {
	my $self = shift;
	my ($q, $a, $g, $c, $tt) = ($self->{question}, $self->{answer}, $self->{guess}, $self->{status}, $self->{time_taken});
	my $res = qq|Question specs:
		Question: 	$q
		Answer:   	$a
		Guess:		$g
		Correct:	$c
		Time taken: $tt secs
	|;
	return $res;
}

=item compare

	Compare given guess with correct answer.
	
	my $result = $q->compare(4);

=cut

sub compare {
	my ($self) = shift;
	$self->guess(shift);
	my ($guess, $answer, $op) = ($self->{guess}, $self->{answer}, $self->{match_operator});
	my $result = 0;
	if ($self->{auto_select}) {
		if (($guess =~ /^\d+$/) && ($answer =~ /^\d+$/)) {
			$op = 'numeric';
		} elsif (($guess =~ /^\w+.*$/) && ($answer =~ /^\w+.*$/)) {
			$op = 'string';
		} else {
			$op = 'regex';
		}
	}
	#non case-sensitive!
    if ( lc($op) eq 'numeric' ) { 
    	$result++ if $guess == $answer;
    } elsif ( lc($op) eq 'string' ) {
    	$result++ if lc($guess) eq lc($answer);
    } else { #default to regex
     	$result++ if $guess =~ /^$answer$/i;
    }  
    return $self->{status} = $result;
}

#private routines.

sub _guessed {
	my $self = shift;
	$self->{time_finished} = time;
	$self->{time_taken} = $self->{time_finished} - $self->{time_started};
}

#
1;
