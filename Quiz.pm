#!/usr/bin/perl 
# Quiz.pm (C) 1998 Richard Foley -> richard@rfitech.com
# For Catherine and Jennifer :-)
#
# Permanent thanks to Tom Phoenix for endless patience and many hints.

#
#Name           	DSLI  		Description                                  	Info
#-------------  	----  		-------------------------------------------- 	-----
#QNA				DcSdLpIO 	Questions and Answers wrapper					RFI

=head1 NAME

Quiz - Questions wrapper.

=cut

package Quiz;
use Question;
use strict;

=head1 SYNOPSIS

	use Quiz;
	use strict;
	my %qz = ('3 * 2' => '6', '2 + 2' => '4',
		'What is the capital of England' => 'London',
		'What are white and fluffy and float in the sky' => 'clouds',
		'7 - 2' => '5',
	);
	my $quiz = Quiz->new(%qz);
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

	Create new Quiz:
	
	my $qz = Quiz->new(%question_n_answers);

=cut

sub new { 
	my $self = {
		all_questions	=> [],
		asked_questions => [],
		current_question => undef,
		right_message	=> "yeay :-)\n",
		wrong_message	=> "tut tut :-(\n",
		difficulty		=> 1,
		retry_limit		=> 3,
		question_time_limit => 15, #secs unimplemented
		quiz_time_limit => 5, #mins unimplemented
		time_started => time,
		'_prompt'			=> undef,
	};
	bless($self, shift);
	my (%h) = @_; #? hash or hashref.
	warn "Quiz expects a hash(@_) of questions 'n' answers as arg.!\n" unless keys %h > 1; #?ref(\%h) eq 'HASH';
	my ($k, $cnt);
	foreach $k (keys %h) {
		push (@{$self->{all_questions}}, Question->new($k, $h{$k}));
		$cnt++;
	}
	$self->{total} = $cnt;
	return $self;
}
#

=prompt

	eg;
	
	$qz->prompt('What is the sum of..:');

=cut

sub prompt {
	my $self = shift;
	my ($prompt) = shift;
	$self->{'_prompt'} = $prompt if $prompt;
	return $self->{'_prompt'};	
}
#

=item unanswered_questions

	Are there any left?
	
	my $qs_left = $qz->unanswered_questions;

=cut

sub unanswered_questions {
	my $self = shift;
	return scalar @{$self->{all_questions}};
}
#

=item next_question

	Basic loop through all questions...
	
	while (1) {
		print $qz->next_question;
	}
	
	or 
	
	while ($qz->unanswered_questions) {
		print $qz->next_question;
	}
		

=cut

sub next_question {
	my $self = shift;
	push (@{$self->{asked_questions}}, $self->{current_question}); 
	$self->{current_question} = pop @{$self->{all_questions}};
	my $cq = $self->{current_question};
	$cq ? return $cq->ask($self->{'_prompt'}) : undef;
}
#

=item question

	Returns current question:
	
	my $qstn = $qz->question;

=cut

sub question {
	my $self = shift;
	return $self->{current_question}{question};
}
#

=item answer

	Returns current answer:
	
	my $ans = $qz->answer;

=cut

sub answer {
	my $self = shift;
	return $self->{current_question}{answer};
}
#

=item correct_questions

	Returns number of correct_questions so far.
	
	print "Got at least ten right!\n" if $qz->correct_questions >= 10;

=cut

sub correct_questions {
	my $self = shift;
	my ($q, $cnt);
	foreach $q (@{$self->{all_questions}}) {
		next unless $q;
		$cnt++ if $q->correct;
	}
	return $cnt;
}
#

=item guess

	Insert guess into system.
	
	my $guess = $qz->guess('some answer');

=cut

sub guess {
	my $self = shift;
	if (@_) {
		my ($guess) = shift;
 		$self->{current_question}->guess($guess);
	}
	return $self->{current_question}->guess;
}
#

=item check_guess

	Better is to check the guess...
	
	my $result = $qz->check_guess('some other answer');

=cut

sub check_guess {
	my $self = shift;
	my ($guess) = shift;
	my $result = $self->{current_question}->compare($guess);
	push(@{$self->{asked_questions}}, $self->{current_question});
	$self->{correct_questions}++ if $result == 1;
	return $result;
}
#

=item finished

	Signal end of quiz:
	
	$qz->finished;

=cut

sub finished {
	my $self = shift;
	$self->{time_finished} = time;
	$self->{time_taken} = $self->{time_finished} - $self->{time_started};
	$self->{all_questions} = $self->{asked_questions}; #reset.
}	
#

=item results

	Simple print out of Quiz results:
	
	print $qz->results;
	
	Also prints out info on each question if asked:
	
	print $qz->results('question');

=cut

sub results {
	my $self = shift;
	$self->finished unless $self->{time_finished};
	my ($qs, $ct, $tt) = ($self->{total}, $self->{correct_questions}, $self->{time_taken});
	my $res = qq|Quiz results:
		Questions: 	$qs
		Correct:	$ct
		Time taken: $tt	secs
	|;	
	my ($detail) = shift;
	if ($detail eq 'question') {
		my $q;
		foreach $q (@{$self->{all_questions}}) {
			next unless $q;
			$res .= $q->results;
		}
	}
	return $res;
}



sub DESTROY {
	my $self = shift;
	print "Done\n";
}

#
1;
